import 'package:intl/intl.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String category;
  final double rating;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.rating,
  });

  factory FoodItem.fromMap(Map<String, dynamic> data, String id) {
    return FoodItem(
      id: id, // ID được truyền từ bên ngoài (key của node)
      name: data['name'] ?? 'Unknown Food',
      description: data['description'] ?? 'No description available.',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'],
      category: data['category'] ?? 'Other',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // ✅ SỬA LỖI: THÊM ID VÀO DỮ LIỆU GHI LÊN FIREBASE
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
    };
  }

  String get formattedPrice {
    final currencyFormatter = NumberFormat('#,##0', 'vi_VN');
    return '${currencyFormatter.format(price)} đ';
  }
}
