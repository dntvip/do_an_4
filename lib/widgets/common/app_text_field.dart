import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? hintText;
  // ✅ THÊM CÁC THAM SỐ MỚI DƯỚI ĐÂY
  final ValueChanged<String>? onChanged; // Thêm onChanged
  final Color? labelColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? fillColor;
  final Widget? suffixIcon; // Thêm suffixIcon

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.hintText,
    //
    this.onChanged,
    this.labelColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.fillColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Sử dụng màu sắc được truyền vào, hoặc fallback về màu của theme
    final effectiveLabelColor = labelColor ?? colorScheme.onSurfaceVariant;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveTextColor = textColor ?? colorScheme.onSurface;
    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final effectiveFillColor = fillColor ?? colorScheme.surface;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: obscure ? 1 : maxLines,
          onChanged: onChanged, // ✅ Gán onChanged vào TextFormField
          style: textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: effectiveTextColor), // ✅ Dùng effectiveTextColor
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            hintStyle: textTheme.bodyMedium!.copyWith(
              fontSize: 15.sp,
              color: effectiveLabelColor.withOpacity(0.6), // ✅ Dùng effectiveLabelColor cho hint
            ),
            labelStyle: textTheme.bodyMedium!.copyWith( // ✅ Thêm labelStyle cho labelText
              fontSize: 15.sp,
              color: effectiveLabelColor,
            ),
            prefixIcon: icon != null ? Icon(icon, color: effectiveIconColor) : null, // ✅ Dùng effectiveIconColor
            suffixIcon: suffixIcon, // ✅ Gán suffixIcon vào InputDecoration
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: effectiveBorderColor, width: 1.w), // ✅ Dùng effectiveBorderColor
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: effectiveBorderColor, width: 1.w), // ✅ Dùng effectiveBorderColor
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: colorScheme.primary, width: 2.w), // Vẫn dùng primary cho focused
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: colorScheme.error, width: 2.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: colorScheme.error, width: 2.w),
            ),
            filled: true,
            fillColor: effectiveFillColor, // ✅ Dùng effectiveFillColor
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          ),
        ),
      ],
    );
  }
}