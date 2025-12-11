import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';
import '../../../widgets/common/app_text.dart';
// ✅ SỬA LẠI ĐƯỜNG DẪN IMPORT
import '../order_detail_screen.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String getOrderStatus(Order order) {
      // Thêm logic để xác định trạng thái đơn hàng nếu cần
      return 'Đã hoàn thành';
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ BỎ HIỂN THỊ MÃ ĐƠN HÀNG
                  AppText(
                    'Đơn hàng', // Chỉ hiển thị text chung
                    textStyle: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  AppText(
                    getOrderStatus(order),
                    color: Colors.green,
                    textStyle: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              const Divider(),
              SizedBox(height: 8.h),
              AppText(
                '${order.items.length} món ăn',
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 4.h),
              AppText(
                'Tổng tiền: ${NumberFormat('#,##0', 'vi_VN').format(order.totalAmount)}đ',
                textStyle: textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              AppText(
                'Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime)}',
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
