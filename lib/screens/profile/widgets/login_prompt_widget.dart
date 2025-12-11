import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';
import '../../auth/login_screen.dart';

class LoginPromptWidget extends StatelessWidget {
  const LoginPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                // ✅ Bọc CircleAvatar hiện tại trong một CircleAvatar khác để tạo viền
                CircleAvatar(
                  radius: 60.3.r, // ✅ Tăng bán kính để tạo không gian cho viền
                  backgroundColor: Colors.black, // ✅ Màu viền đen
                  child: CircleAvatar(
                    radius: 60.r, // ✅ Bán kính icon ban đầu
                    backgroundColor: const Color(0xFFF0F0F0),
                    child: Icon(Icons.person_off_outlined,
                        size: 60.sp, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 28.h),
                AppText(
                  'Chào mừng!',
                  textStyle: textTheme.headlineMedium!.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  color: Colors.black87,
                ),
                SizedBox(height: 12.h),
                AppText(
                  'Đăng nhập để thưởng thức những món ngon cùng cơm nhà nấu.',
                  textAlign: TextAlign.center,
                  textStyle: textTheme.bodyLarge!.copyWith(
                    fontSize: 16.sp,
                  ),
                  color: Colors.grey.shade600,
                ),
                SizedBox(height: 36.h),
                AppButton(
                  label: 'Đăng nhập / Đăng ký',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  icon: Icon(Icons.login, size: 20.sp),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    textStyle: textTheme.labelLarge!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        // Nút quay lại
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 8.w,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black54),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
            tooltip: 'Quay lại',
          ),
        ),
      ],
    );
  }
}
