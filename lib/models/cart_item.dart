import 'package:equatable/equatable.dart';
import 'food_item.dart';

class CartItem extends Equatable {
  final FoodItem food;
  final int quantity;

  CartItem({
    required this.food,
    required this.quantity,
  });

  @override
  List<Object?> get props => [food, quantity];

  CartItem copyWith({
    FoodItem? food,
    int? quantity,
  }) {
    return CartItem(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'food': food.toMap(),
      'quantity': quantity,
    };
  }

  // ✅ SỬA LẠI HÀM fromMap ĐỂ NHẬN foodId TỪ BÊN NGOÀI
  factory CartItem.fromMap(Map<String, dynamic> map, String foodId) {
    final foodData = Map<String, dynamic>.from(map['food'] as Map);
    // Sử dụng foodId được truyền vào, là nguồn ID đáng tin cậy nhất
    return CartItem(
      food: FoodItem.fromMap(foodData, foodId),
      quantity: map['quantity'] ?? 1,
    );
  }
}
