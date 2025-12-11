import 'package:flutter/material.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/cart_empty_view.dart';
import 'widgets/cart_item_tile.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/app_text.dart';
import '../../screens/checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;
    final total = cartProvider.totalAmount;
    final isLoading = cartProvider.isLoading;

    Widget buildBody() {
      // ✅ BƯỚC 1: KIỂM TRA TRẠNG THÁI ĐANG TẢI
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      // ✅ BƯỚC 2: KIỂM TRA GIỎ HÀNG CÓ RỖNG KHÔNG
      if (cartItems.isEmpty) {
        return const CartEmptyView();
      }

      // ✅ BƯỚC 3: HIỂN THỊ DANH SÁCH NẾU CÓ DỮ LIỆU
      return ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (_, index) {
          final foodId = cartItems.keys.elementAt(index);
          final item = cartItems[foodId]!;
          return CartItemTile(foodId: foodId, item: item);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          'Giỏ hàng',
          textStyle: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
            fontSize: 20.sp,
          ),
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: buildBody(),
      // Chỉ hiển thị bottom bar khi có sản phẩm và không đang tải
      bottomNavigationBar: (cartItems.isNotEmpty && !isLoading)
          ? CartBottomBar(
              total: total,
              onCheckout: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                }
              },
            )
          : null,
    );
  }
}
