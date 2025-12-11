import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../models/cart_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/quantity_button.dart';
import '../../../widgets/common/network_image_with_loader.dart'; // ✅ IMPORT WIDGET MỚI

class CartItemTile extends StatelessWidget {
  final String foodId;
  final CartItem item;

  const CartItemTile({
    super.key,
    required this.foodId,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh món ăn
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              // ✅ SỬ DỤNG WIDGET MỚI
              child: NetworkImageWithLoader(
                imageUrl: item.food.imageUrl,
                width: 80.w,
                height: 80.w,
              ),
            ),

            SizedBox(width: 12.w),

            // Thông tin món + số lượng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên món ăn
                  AppText(
                    item.food.name,
                    textStyle: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 16.sp,
                    ),
                    color: colorScheme.onSurface,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // Giá đơn
                  AppText(
                    item.food.formattedPrice,
                    textStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 13.sp,
                    ),
                    color: Colors.grey[700],
                  ),
                  SizedBox(height: 8.h),

                  // Số lượng
                  Row(
                    children: [
                      QuantityButton(
                        icon: Icons.remove,
                        onPressed: () => cart.decreaseQuantity(item.food.id),
                        iconColor: colorScheme.primary,
                        borderColor: colorScheme.primary,
                        backgroundColor: colorScheme.surface,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: AppText(
                          item.quantity.toString(),
                          textStyle: theme.textTheme.bodyLarge!.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          color: colorScheme.onSurface,
                        ),
                      ),
                      QuantityButton(
                        icon: Icons.add,
                        onPressed: () => cart.increaseQuantity(item.food.id),
                        iconColor: colorScheme.primary,
                        borderColor: colorScheme.primary,
                        backgroundColor: colorScheme.surface,
                      ),
                    ], 
                  ),
                ],
              ),
            ),

            // Xóa
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: () => cart.removeFromCart(foodId),
              tooltip: 'Xóa món',
            ),
          ],
        ),
      ),
    );
  }
}
