import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:provider/provider.dart';

import '../../services/order_service.dart';
import '../../models/order.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/app_screen_layout.dart'; // Import AppScreenLayout
import '../../widgets/common/app_text.dart'; // Import AppText

import 'widgets/order_card.dart';
import 'widgets/order_empty.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _ordersFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = context.read<UserProvider>().user?.uid;
    // Kiểm tra và khởi tạo _ordersFuture chỉ khi userId có sẵn
    if (userId != null) {
      _ordersFuture = OrderService().getOrdersByUser(userId);
    } else {
      _ordersFuture = Future.value([]); // Trả về danh sách rỗng nếu không có userId
    }
  }

  // Thêm chức năng pull-to-refresh
  Future<void> _refreshOrders() async {
    final userId = context.read<UserProvider>().user?.uid;
    if (userId != null) {
      setState(() {
        _ordersFuture = OrderService().getOrdersByUser(userId);
      });
    } else {
      setState(() {
        _ordersFuture = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenLayout( // Sử dụng AppScreenLayout
      appBar: AppBar(
        title: AppText( // Sử dụng AppText cho tiêu đề AppBar
          'Lịch sử đơn hàng',
          textStyle: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
            fontSize: 20.sp,
          ),
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Lỗi lấy đơn hàng: ${snapshot.error}');
            return Center(
              child: AppText( // Sử dụng AppText cho thông báo lỗi
                'Lỗi: ${snapshot.error}',
                color: Theme.of(context).colorScheme.error,
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const OrderEmpty();
          }

          return RefreshIndicator( // Thêm RefreshIndicator
            onRefresh: _refreshOrders,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w), // Sử dụng .w
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          );
        },
      ),
    );
  }
}