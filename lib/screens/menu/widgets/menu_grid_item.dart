import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/food_item.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/network_image_with_loader.dart';

class MenuGridItem extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const MenuGridItem({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // ✅ SỬ DỤNG WIDGET MỚI
                child: NetworkImageWithLoader(
                  imageUrl: food.imageUrl,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      food.name,
                      textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 16.sp,
                          ),
                      color: colorScheme.onSurface,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      food.formattedPrice,
                      textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
