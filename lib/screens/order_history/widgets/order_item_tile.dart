import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import '../../../models/cart_item.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/network_image_with_loader.dart'; // ✅ IMPORT WIDGET MỚI

class OrderItemTile extends StatelessWidget {
  final CartItem item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          // ✅ SỬ DỤNG WIDGET MỚI
          child: NetworkImageWithLoader(
            imageUrl: item.food.imageUrl,
            width: 60.w,
            height: 60.h,
          ),
        ),
        title: AppText(
          item.food.name,
          textStyle: textTheme.titleMedium!.copyWith(fontSize: 16.sp),
        ),
        subtitle: AppText(
          'Giá: ${item.food.formattedPrice}\nSố lượng: ${item.quantity}',
          textStyle: textTheme.bodySmall!.copyWith(fontSize: 13.sp),
        ),
        isThreeLine: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
