import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/food_item.dart';
import '../../../../widgets/common/network_image_with_loader.dart'; // ✅ IMPORT WIDGET MỚI

class FoodDetailImage extends StatelessWidget {
  final FoodItem food;

  const FoodDetailImage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        // ✅ SỬ DỤNG WIDGET TÁI SỬ DỤNG
        child: NetworkImageWithLoader(
          imageUrl: food.imageUrl,
          width: double.infinity,
          height: 240.h,
        ),
      ),
    );
  }
}
