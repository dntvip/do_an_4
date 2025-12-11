import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ Import ScreenUtil
import '../../../widgets/common/app_text.dart'; // ✅ Import AppText

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0.w), // ✅ Dùng .h, .w
      elevation: 2.r, // ✅ Dùng .r cho elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), // ✅ Dùng .r
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? colorScheme.primary, // ✅ Sử dụng colorScheme.primary
          size: 24.sp, // ✅ Dùng .sp cho kích thước icon
        ),
        title: AppText( // ✅ Sử dụng AppText
          title,
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith( // bodyLarge hoặc titleMedium
            fontSize: 16.sp, // ✅ Dùng .sp
            fontWeight: FontWeight.w500,
          ),
          color: colorScheme.onSurface, // Màu chữ phù hợp với theme
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp, // ✅ Dùng .sp
          color: Colors.grey.shade500, // Màu mũi tên
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h), // ✅ Dùng .w, .h
      ),
    );
  }
}