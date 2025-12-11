import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/food_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/network_image_with_loader.dart'; // ✅ IMPORT WIDGET MỚI

import 'widgets/appbar_food_detail.dart';
import 'widgets/description_food_detail.dart';
import 'widgets/bottombar_food_detail.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;
  late FoodItem _food;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final food = ModalRoute.of(context)!.settings.arguments as FoodItem;
    _food = food;
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final totalPrice = _food.price * quantity;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarFoodDetail(food: _food),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ✅ SỬ DỤNG WIDGET MỚI
              NetworkImageWithLoader(
                imageUrl: _food.imageUrl,
                width: double.infinity,
                height: 250.h,
              ),
              DescriptionFoodDetail(
                food: _food,
                quantity: quantity,
                onIncrease: _increaseQuantity,
                onDecrease: _decreaseQuantity,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarFoodDetail(
        totalPrice: totalPrice,
        onAddToCart: () {
          cartProvider.addToCart(_food, quantity);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppText(
                  '${_food.name} đã được thêm vào giỏ hàng!',
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                ),
                backgroundColor: colorScheme.primary,
              ),
            );
          }
        },
      ),
    );
  }
}
