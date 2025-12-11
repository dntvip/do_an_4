import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/food_item.dart';
import '../../../../widgets/common/app_text.dart';
import '../../../../widgets/common/quantity_button.dart';

class DescriptionFoodDetail extends StatelessWidget {
  final FoodItem food;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const DescriptionFoodDetail({
    super.key,
    required this.food,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            food.name,
            textStyle: textTheme.headlineMedium!.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
            color: colorScheme.onBackground,
          ),
          SizedBox(height: 10.h),
          Divider(color: colorScheme.outlineVariant, thickness: 1),
          SizedBox(height: 10.h),
          AppText(
            'Mô tả sản phẩm:',
            textStyle: textTheme.titleMedium!.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            color: colorScheme.onBackground,
          ),
          SizedBox(height: 8.h),
          AppText(
            food.description,
            textStyle: textTheme.bodyMedium!.copyWith(
              fontSize: 15.sp,
              color: colorScheme.onBackground.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                food.formattedPrice, // ✅ Đã sử dụng formattedPrice ở đây
                textStyle: textTheme.headlineSmall!.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                color: colorScheme.primary,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuantityButton(
                    icon: Icons.remove,
                    onPressed: onDecrease,
                    iconColor: colorScheme.primary,
                    borderColor: colorScheme.primary,
                    backgroundColor: colorScheme.surface,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: AppText(
                      '$quantity',
                      textStyle: textTheme.bodyLarge!.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      color: colorScheme.onSurface,
                    ),
                  ),
                  QuantityButton(
                    icon: Icons.add,
                    onPressed: onIncrease,
                    iconColor: colorScheme.primary,
                    borderColor: colorScheme.primary,
                    backgroundColor: colorScheme.surface,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}