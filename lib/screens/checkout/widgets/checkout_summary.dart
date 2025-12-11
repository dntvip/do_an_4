import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // Import IntL cho định dạng tiền tệ
import '../../../widgets/common/app_text.dart'; // Import AppText

class CheckoutSummary extends StatelessWidget {
  final double totalAmount;

  const CheckoutSummary({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat('#,##0', 'vi_VN'); // Định dạng tiền tệ

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          'Tổng tiền:',
          textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          color: colorScheme.onSurface,
        ),
        AppText(
          currencyFormatter.format(totalAmount) + ' đ',
          textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          color: colorScheme.primary,
        ),
      ],
    );
  }
}