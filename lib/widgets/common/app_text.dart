import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle; // Nhận TextStyle trực tiếp
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final String? fontFamily;

  const AppText(
      this.text, {
        super.key,
        this.textStyle,
        this.color,
        this.fontWeight,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.height,
        this.fontFamily,
      });

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium!;

    TextStyle finalStyle = defaultStyle.copyWith(
      fontSize: defaultStyle.fontSize != null ? defaultStyle.fontSize!.sp : null,
      color: color ?? defaultStyle.color,
      fontWeight: fontWeight ?? defaultStyle.fontWeight,
      height: height ?? defaultStyle.height,
      fontFamily: fontFamily ?? defaultStyle.fontFamily,
    );

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}