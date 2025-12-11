import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/user_provider.dart';
import '../../widgets/common/app_screen_layout.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/common/app_button.dart';
import '../address/mapbox_screen.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/login_prompt_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isGoogleProvider() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return false;
    return firebaseUser.providerData.any((userInfo) => userInfo.providerId == 'google.com');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final appUser = userProvider.user;
    final isLoading = userProvider.isLoading;

    Widget buildBody() {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (appUser == null) {
        return const LoginPromptWidget();
      } else {
        return Column(
          children: [
            const ProfileHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  SizedBox(height: 24.h),
                  AppText('Tài khoản', color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                  SizedBox(height: 8.h),
                  ProfileMenuItem(
                    icon: Icons.person,
                    title: 'Thông tin cá nhân',
                    onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                  ),
                  if (!_isGoogleProvider())
                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Đổi mật khẩu',
                      onTap: () => Navigator.pushNamed(context, '/change-password'),
                    ),
                  SizedBox(height: 24.h),
                  AppText('Hoạt động', color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                  SizedBox(height: 8.h),
                  ProfileMenuItem(
                    icon: Icons.receipt_long,
                    title: 'Đơn hàng của tôi',
                    onTap: () => Navigator.pushNamed(context, '/order-history'),
                  ),
                   ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Địa chỉ của tôi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapboxScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                  AppButton(
                    label: 'Đăng xuất',
                    onPressed: () => userProvider.signOut(),
                    icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        );
      }
    }

    return AppScreenLayout(
      appBar: AppBar(
        title: const AppText('Hồ sơ'),
        bottom: null,
      ),
      body: buildBody(),
    );
  }
}
