import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_text_field.dart';


class MenuCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const MenuCustomAppBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Các màu sắc để tạo sự NHẸ NHÀNG và HÀI HÒA
    final Color appBarContentColor = colorScheme.onPrimary;
    final Color textFieldFillColor = Colors.white.withOpacity(0.9);
    final Color textFieldContentColor = Colors.black87;
    final Color textFieldHintColor = Colors.grey.shade600;

    return Material(
      elevation: 3,
      color: colorScheme.primary, // Màu nền của App Bar (giữ nguyên)
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20.r), // Bo tròn góc dưới
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.w,
          statusBarHeight + 12.h, // Padding trên bao gồm chiều cao status bar
          16.w,
          16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  AppText(
                    'Cơm Nhà Nấu',
                    // ✅ THAY THẾ style: AppTextStyle.headline
                    textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith( // Hoặc headlineLarge
                      fontSize: 28.sp, // Đảm bảo kích thước phù hợp
                    ),
                    color: appBarContentColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Borel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    '~ Ngon Như Mẹ Làm ~',
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith( // Hoặc bodyMedium, labelSmall
                      fontSize: 14.sp, // Đảm bảo kích thước phù hợp
                    ),
                    color: appBarContentColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Borel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            AppTextField(
              controller: searchController,
              label: 'Tìm món...',
              icon: Icons.search,
              onChanged: onSearchChanged,
              labelColor: textFieldHintColor,
              borderColor: null,
              textColor: textFieldContentColor,
              iconColor: textFieldHintColor,
              fillColor: textFieldFillColor,
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 20.sp,
                  color: textFieldHintColor,
                ),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                },
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 60.h);
}