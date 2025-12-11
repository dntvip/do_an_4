import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_text.dart'; // Import AppText

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Widget? icon; // Có thể là Icon hoặc bất kỳ Widget nào khác
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elevatedButtonTheme = theme.elevatedButtonTheme;
    final outlinedButtonTheme = theme.outlinedButtonTheme;

    // Xác định kiểu nút để lấy default style phù hợp
    bool isOutlinedButton = false;
    if (style != null) {
      final BorderSide? resolvedSide = style!.side?.resolve({});
      if (resolvedSide != null && resolvedSide.width > 0) {
        isOutlinedButton = true;
      }
    }

    // Default styles for text and foreground/background colors
    // ✅ GIẢM KÍCH THƯỚC FONT MẶC ĐỊNH CHO NÚT
    final TextStyle defaultTextStyle = (isOutlinedButton
        ? outlinedButtonTheme.style?.textStyle?.resolve({})
        : elevatedButtonTheme.style?.textStyle?.resolve({})) ?? theme.textTheme.labelLarge!.copyWith(
      fontSize: 16.sp, // ✅ Giảm từ 18.sp xuống 16.sp hoặc 15.sp
      fontWeight: FontWeight.w600,
    );

    final Color defaultForegroundColor = isOutlinedButton
        ? outlinedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.primary
        : elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary;

    // Content of the button (label or loading indicator)
    Widget buttonContent;
    if (loading) {
      buttonContent = SizedBox(
        width: 24.sp,
        height: 24.sp,
        child: CircularProgressIndicator(
          color: defaultForegroundColor,
          strokeWidth: 2.w,
        ),
      );
    } else {
      buttonContent = AppText(
        label,
        textStyle: style?.textStyle?.resolve({}) ?? defaultTextStyle,
        color: style?.foregroundColor?.resolve({}) ?? defaultForegroundColor,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Icon handling: wrap icon in sized box for consistent spacing/size
    Widget? iconWidget;
    if (icon != null && !loading) {
      iconWidget = SizedBox(
        width: 24.sp, // Kích thước cố định cho icon
        height: 24.sp,
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              size: 20.sp, // Kích thước icon bên trong nút
              color: style?.foregroundColor?.resolve({}) ?? defaultForegroundColor,
            ),
            child: icon!,
          ),
        ),
      );
    }

    // Determine the actual button widget (ElevatedButton or OutlinedButton)
    Widget buttonWidget;
    // Lấy padding mặc định cho nút để điều chỉnh nếu cần
    EdgeInsetsGeometry defaultPadding = isOutlinedButton
        ? outlinedButtonTheme.style?.padding?.resolve({}) ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h) // Default padding for outlined
        : elevatedButtonTheme.style?.padding?.resolve({}) ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h); // Default padding for elevated

    // Tạo ButtonStyle tùy chỉnh nếu cần, để áp dụng padding
    ButtonStyle effectiveStyle = (style ?? (isOutlinedButton ? outlinedButtonTheme.style : elevatedButtonTheme.style) ?? const ButtonStyle()).copyWith(
      padding: MaterialStateProperty.all(defaultPadding), // Đảm bảo padding được áp dụng
    );


    if (isOutlinedButton) {
      if (iconWidget != null) {
        buttonWidget = OutlinedButton.icon(
          onPressed: loading ? null : onPressed,
          style: effectiveStyle, // ✅ Sử dụng effectiveStyle
          icon: iconWidget,
          label: buttonContent,
        );
      } else {
        buttonWidget = OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: effectiveStyle, // ✅ Sử dụng effectiveStyle
          child: buttonContent,
        );
      }
    } else {
      if (iconWidget != null) {
        buttonWidget = ElevatedButton.icon(
          onPressed: loading ? null : onPressed,
          style: effectiveStyle, // ✅ Sử dụng effectiveStyle
          icon: iconWidget,
          label: buttonContent,
        );
      } else {
        buttonWidget = ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: effectiveStyle, // ✅ Sử dụng effectiveStyle
          child: buttonContent,
        );
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 48.h, // Fixed height for consistency
      child: buttonWidget,
    );
  }
}