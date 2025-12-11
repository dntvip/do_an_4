import 'package:firebase_database/firebase_database.dart';
import '../models/order.dart';

class OrderService {
  final _ordersRef = FirebaseDatabase.instance.ref('orders');

  Future<List<Order>> getOrdersByUser(String userId) async {
    try {
      final userOrdersRef = _ordersRef.child(userId);
      final snapshot = await userOrdersRef.once();

      final data = snapshot.snapshot.value;
      if (data == null) {
        // Không có đơn hàng nào, trả về danh sách rỗng
        return [];
      }

      // ✅ KIỂM TRA KIỂU DỮ LIỆU MỘT CÁCH AN TOÀN
      if (data is Map) {
        final orders = <Order>[];
        // Ép kiểu an toàn sang Map<Object?, Object?> trước
        final map = data as Map<Object?, Object?>;

        map.forEach((key, value) {
          if (key is String && value is Map) {
            final orderId = key;
            final orderData = Map<String, dynamic>.from(value);
            try {
              orders.add(Order.fromMap(orderId, orderData));
            } catch (e) {
              print('Error parsing order object with ID $orderId: $e');
            }
          }
        });

        // Sắp xếp lại danh sách, đơn hàng mới nhất ở trên cùng
        orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        return orders;
      } else {
        // Nếu dữ liệu không phải là Map, trả về danh sách rỗng
        return [];
      }
    } catch (e) {
      print('FATAL Error fetching orders for user $userId: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi nghiêm trọng
    }
  }
}
