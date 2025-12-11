import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/food_item.dart';

const String _guestCartKey = 'guestCart';

class CartProvider extends ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('carts');
  StreamSubscription<DatabaseEvent>? _cartSubscription;

  Map<String, CartItem> _items = {};
  String? _currentUserId;
  bool _isLoading = false;
  bool _isMerging = false; // ✅ CÔNG TẮC AN TOÀN

  Map<String, CartItem> get items => {..._items};
  bool get isLoading => _isLoading;

  CartProvider() {
    _loadGuestCartFromPrefs();
  }

  Future<void> _loadGuestCartFromPrefs() async {
    if (_currentUserId == null) {
      _isLoading = true;
      notifyListeners();
      try {
        final prefs = await SharedPreferences.getInstance();
        final cartString = prefs.getString(_guestCartKey);
        if (cartString != null) {
          final Map<String, dynamic> cartMap = json.decode(cartString);
          _items = cartMap.map((key, value) => 
            MapEntry(key, CartItem.fromMap(Map<String, dynamic>.from(value), key))
          );
        }
      } catch (e) {
        // Bỏ qua lỗi nếu không đọc được
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveGuestCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = json.encode(
      _items.map((key, value) => MapEntry(key, value.toMap()))
    );
    await prefs.setString(_guestCartKey, cartString);
  }

  Future<void> _clearGuestCartPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestCartKey);
  }

  void setUserId(String? userId) {
    if (userId == _currentUserId) return;

    _cartSubscription?.cancel();

    if (userId != null) {
      final guestCart = {..._items};
      _currentUserId = userId;
      _items.clear();
      _isLoading = true;
      _isMerging = false; // ✅ Reset "công tắc" khi có người dùng mới
      notifyListeners();

      _cartSubscription = _db.child(userId).onValue.listen(
        (event) {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;
          _items = data?.map((key, value) =>
            MapEntry(key as String, CartItem.fromMap(Map<String, dynamic>.from(value as Map), key as String))
          ) ?? {};

          // ✅ KIỂM TRA "CÔNG TẮC" TRƯỚC KHI HỢP NHẤT
          if (guestCart.isNotEmpty && !_isMerging) {
            _isMerging = true; // ✅ BẬT "CÔNG TẮC" NGAY LẬP TỨC
            _mergeGuestCart(guestCart).then((_) => _clearGuestCartPrefs());
          }

          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          notifyListeners();
        },
      );
    } else {
      _currentUserId = null;
      _items.clear();
      _isMerging = false; // ✅ Reset "công tắc"
      _loadGuestCartFromPrefs();
      notifyListeners();
    }
  }

  Future<void> _mergeGuestCart(Map<String, CartItem> guestCart) async {
    if (_currentUserId == null) return;
    for (var entry in guestCart.entries) {
      final foodId = entry.key;
      final guestItem = entry.value;
      final userItemRef = _db.child(_currentUserId!).child(foodId);
      
      // Dùng transaction để đảm bảo tính toàn vẹn dữ liệu khi cộng dồn
      await userItemRef.runTransaction((Object? currentData) { // ✅ SỬA LỖI CÚ PHÁP
        if (currentData == null) {
          return Transaction.success(guestItem.toMap());
        }

        final currentMap = Map<String, dynamic>.from(currentData as Map);
        final currentQuantity = currentMap['quantity'] as int;
        currentMap['quantity'] = currentQuantity + guestItem.quantity;

        return Transaction.success(currentMap);
      });
    }
  }

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.food.price * item.quantity);
  }

  Future<void> addToCart(FoodItem food, int quantity) async {
    if (_currentUserId != null) {
      final itemRef = _db.child(_currentUserId!).child(food.id);
      await itemRef.runTransaction((Object? currentData) {
         if (currentData == null) {
          return Transaction.success(CartItem(food: food, quantity: quantity).toMap());
        }
        final currentMap = Map<String, dynamic>.from(currentData as Map);
        currentMap['quantity'] = (currentMap['quantity'] as int) + quantity;
        return Transaction.success(currentMap);
      });
    } else {
      _items.update(
        food.id,
        (existing) => existing.copyWith(quantity: existing.quantity + quantity),
        ifAbsent: () => CartItem(food: food, quantity: quantity),
      );
      notifyListeners();
      await _saveGuestCartToPrefs();
    }
  }

  Future<void> removeFromCart(String foodId) async {
    if (_currentUserId != null) {
      await _db.child(_currentUserId!).child(foodId).remove();
    } else {
      _items.remove(foodId);
      notifyListeners();
      await _saveGuestCartToPrefs();
    }
  }

  Future<void> clearCart() async {
    if (_currentUserId != null) {
      await _db.child(_currentUserId!).remove();
    } else {
      _items.clear();
      notifyListeners();
      await _saveGuestCartToPrefs();
    }
  }

  Future<void> increaseQuantity(String foodId) async {
    if (_currentUserId != null) {
      await _db.child(_currentUserId!).child(foodId).child('quantity').runTransaction((Object? current) {
        if (current == null) return Transaction.abort();
        return Transaction.success((current as int) + 1);
      });
    } else {
       if (_items.containsKey(foodId)) {
        _items.update(foodId, (item) => item.copyWith(quantity: item.quantity + 1));
        notifyListeners();
        await _saveGuestCartToPrefs();
      }
    }
  }

  Future<void> decreaseQuantity(String foodId) async {
    if (_currentUserId != null) {
      final itemRef = _db.child(_currentUserId!).child(foodId).child('quantity');
       await itemRef.runTransaction((Object? current) {
        if (current == null) return Transaction.abort();
        final currentQuantity = current as int;
        if (currentQuantity <= 1) {
          itemRef.parent?.remove();
          return Transaction.abort();
        }
        return Transaction.success(currentQuantity - 1);
      });
    } else {
      if (_items.containsKey(foodId)) {
        if (_items[foodId]!.quantity > 1) {
          _items.update(foodId, (item) => item.copyWith(quantity: item.quantity - 1));
        } else {
          _items.remove(foodId);
        }
        notifyListeners();
        await _saveGuestCartToPrefs();
      }
    }
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}
