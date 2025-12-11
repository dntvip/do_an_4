// lib/widgets/common/quantity_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? iconColor;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.buttonColor,
    this.borderColor,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultButtonColor = buttonColor ?? colorScheme.primary;
    final defaultBorderColor = borderColor ?? colorScheme.primary;
    final defaultBackgroundColor = backgroundColor ?? colorScheme.surface;
    final defaultIconColor = iconColor ?? colorScheme.onSurface; // Mặc định màu icon là onSurface

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        border: Border.all(color: defaultBorderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16.sp),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        color: defaultIconColor, // Sử dụng màu icon mặc định hoặc được truyền vào
        splashRadius: 20.r,
      ),
    );
  }
}