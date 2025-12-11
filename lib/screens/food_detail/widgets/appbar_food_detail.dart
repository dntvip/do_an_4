import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/food_item.dart';
import '../../../../widgets/common/app_text.dart'; // Import AppText

// ✅ XÓA IMPORT 'app_text_style.dart'; (nếu có)

class AppBarFoodDetail extends StatelessWidget implements PreferredSizeWidget {
  final FoodItem food;

  const AppBarFoodDetail({super.key, required this.food});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10.h);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: AppText(
        food.name,
        // ✅ THAY style: AppTextStyle.title BẰNG textStyle: Theme.of(context).textTheme.titleLarge
        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        color: colorScheme.onPrimaryContainer,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Borel',
      ),
      centerTitle: true,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      iconTheme: IconThemeData(
        size: 24.sp,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}