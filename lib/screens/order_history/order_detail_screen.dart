import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

import '../../models/order.dart';
import '../../widgets/common/app_screen_layout.dart'; // Import AppScreenLayout
import '../../widgets/common/app_text.dart'; // Import AppText

import 'widgets/order_item_tile.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final textTheme = Theme.of(context).textTheme;

    return AppScreenLayout( // Sử dụng AppScreenLayout
      appBar: AppBar(
        title: AppText( // Sử dụng AppText cho tiêu đề AppBar
          'Chi tiết đơn hàng',
          textStyle: textTheme.titleLarge!.copyWith(fontSize: 20.sp),
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w), // Sử dụng .w
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText( // Sử dụng AppText
              'Ngày đặt: $formattedDate',
              textStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(height: 12.h), // Sử dụng .h
            ...order.items.map((item) => OrderItemTile(item: item)).toList(),
            SizedBox(height: 12.h), // Sử dụng .h
            if (order.note != null && order.note!.isNotEmpty)
              AppText( // Sử dụng AppText
                'Ghi chú: ${order.note!}',
                textStyle: textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
              ),
            SizedBox(height: 8.h), // Sử dụng .h
            if (order.shippingAddress != null)
              AppText( // Sử dụng AppText
                'Địa chỉ giao hàng: ${order.shippingAddress!}',
                textStyle: textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
              ),
            SizedBox(height: 8.h), // Sử dụng .h
            AppText( // Sử dụng AppText
              'Phương thức thanh toán: ${order.paymentMethod ?? 'Không rõ'}',
              textStyle: textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h), // Sử dụng .h
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText( // Sử dụng AppText
                  'Tổng thanh toán:',
                  textStyle: textTheme.titleMedium!.copyWith(fontSize: 16.sp),
                ),
                AppText( // Sử dụng AppText
                  currencyFormat.format(order.totalAmount),
                  textStyle: textTheme.titleMedium!.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}