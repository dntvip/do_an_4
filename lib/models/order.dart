import 'package:equatable/equatable.dart';
import 'cart_item.dart'; // Đảm bảo import CartItem

class Order extends Equatable {
  String id;
  String? displayId; // ✅ THÊM TRƯỜNG MÃ ĐƠN HÀNG DỄ ĐỌC
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;
  final String? shippingAddress;
  final String? note;
  final String? paymentMethod;

  Order({
    required this.id,
    this.displayId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    this.shippingAddress,
    this.note,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    id,
    displayId,
    userId,
    items,
    totalAmount,
    dateTime,
    shippingAddress,
    note,
    paymentMethod
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayId': displayId,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
      'shippingAddress': shippingAddress,
      'note': note,
      'paymentMethod': paymentMethod,
    };
  }

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    var itemsList = <CartItem>[];
    if (map['items'] is List) {
      final itemsData = map['items'] as List;
      itemsList = itemsData.map((itemData) {
        final itemMap = Map<String, dynamic>.from(itemData as Map);
        final foodId = itemMap['food']?['id'] as String? ?? '';
        return CartItem.fromMap(itemMap, foodId);
      }).toList();
    } else if (map['items'] is Map) {
      final itemsData = map['items'] as Map;
       itemsList = itemsData.entries.map((entry) {
        final itemMap = Map<String, dynamic>.from(entry.value as Map);
        final foodId = itemMap['food']?['id'] as String? ?? '';
        return CartItem.fromMap(itemMap, foodId);
      }).toList();
    }

    return Order(
      id: id,
      displayId: map['displayId'] as String?,
      userId: map['userId'] ?? '',
      items: itemsList,
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      shippingAddress: map['shippingAddress'],
      note: map['note'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
