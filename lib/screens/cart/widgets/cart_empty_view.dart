import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/common/app_text.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: AppText(
        "Giỏ hàng của bạn đang trống",
        textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontSize: 18.sp, // Kích thước chữ tùy chỉnh
        ),
        color: colorScheme.onBackground.withOpacity(0.7),
        textAlign: TextAlign.center,
      ),
    );
  }
}