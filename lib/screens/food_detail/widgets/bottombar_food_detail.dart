import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/common/app_text.dart'; // ✅ Import AppText

// ✅ XÓA IMPORT 'app_text_style.dart'; (nếu có)

class BottomBarFoodDetail extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onAddToCart;

  const BottomBarFoodDetail({
    super.key,
    required this.totalPrice,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat('#,##0', 'vi_VN');

    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: AppText(
                'Tổng: ${currencyFormatter.format(totalPrice)} đ',
                // ✅ THAY style: AppTextStyle.price BẰNG textStyle: Theme.of(context).textTheme.headlineSmall
                textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
                color: colorScheme.primary,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          ElevatedButton.icon(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 5,
            ),
            icon: Icon(Icons.shopping_cart_outlined, size: 20.sp,color: colorScheme.onPrimary,),
            label: AppText(
              'Thêm vào giỏ',
              // ✅ THAY style: AppTextStyle.button BẰNG textStyle: Theme.of(context).textTheme.labelLarge
              textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              color: colorScheme.onPrimary,
            ),
          )
        ],
      ),
    );
  }
}