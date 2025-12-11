import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // ✅ Thêm import này
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';

class CartBottomBar extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;

  const CartBottomBar({
    super.key,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat('#,##0', 'vi_VN'); // ✅ Khởi tạo NumberFormat

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              'Tổng: ${currencyFormatter.format(total)}đ', // ✅ Áp dụng định dạng ở đây
              textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppButton(
              label: 'Đặt hàng',
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}