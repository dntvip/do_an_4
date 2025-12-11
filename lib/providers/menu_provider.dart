import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/food_item.dart';

class MenuProvider extends ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('foodItems');
  StreamSubscription<DatabaseEvent>? _foodItemsSubscription;

  List<FoodItem> _allFoodItems = [];
  List<FoodItem> _filteredFoodItems = [];
  bool _isLoading = true;

  String _searchQuery = '';
  String _selectedCategory = '';

  // Getters cho UI
  List<FoodItem> get filteredFoodItems => _filteredFoodItems;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  MenuProvider() {
    _listenToFoodItems();
  }

  void _listenToFoodItems() {
    _isLoading = true;
    notifyListeners();

    _foodItemsSubscription = _db.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _allFoodItems = data.entries.map((entry) {
          final itemMap = Map<String, dynamic>.from(entry.value as Map);
          return FoodItem.fromMap(itemMap, entry.key as String);
        }).toList();
        _filterItems(); // Lọc ngay sau khi có dữ liệu mới
      } else {
        _allFoodItems = [];
        _filteredFoodItems = [];
      }
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      _allFoodItems = [];
      _filteredFoodItems = [];
      notifyListeners();
    });
  }

  void _filterItems() {
    List<FoodItem> tempItems = [..._allFoodItems];

    // Lọc theo danh mục
    if (_selectedCategory.isNotEmpty) {
      tempItems = tempItems.where((item) => item.category == _selectedCategory).toList();
    }

    // Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      tempItems = tempItems.where((item) => 
        item.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    _filteredFoodItems = tempItems;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterItems();
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory == category) {
      _selectedCategory = ''; // Bỏ chọn nếu nhấn lại
    } else {
      _selectedCategory = category;
    }
    _filterItems();
  }

  @override
  void dispose() {
    _foodItemsSubscription?.cancel();
    super.dispose();
  }
}
