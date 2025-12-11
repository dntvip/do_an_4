import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/common/app_screen_layout.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar('Bạn chưa đăng nhập.', Colors.red);
        return;
      }

      // 1. Xác thực lại người dùng bằng mật khẩu hiện tại
      // Đây là bước quan trọng để bảo mật, ngăn chặn việc đổi mật khẩu trái phép
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, // Đảm bảo email của người dùng hiện tại
        password: _currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // 2. Cập nhật mật khẩu mới
      await user.updatePassword(_newPasswordController.text.trim());

      _showSnackBar('Mật khẩu đã được thay đổi thành công!', Colors.green);
      if (mounted) {
        Navigator.pop(context); // Quay lại màn hình hồ sơ
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'wrong-password') {
        message = 'Mật khẩu hiện tại không đúng.';
      } else if (e.code == 'too-many-requests') {
        message = 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
      } else if (e.code == 'requires-recent-login') {
        // Lỗi này xảy ra khi người dùng đã đăng nhập quá lâu mà không có hoạt động gần đây
        message = 'Để đổi mật khẩu, vui lòng đăng xuất và đăng nhập lại.';
      } else if (e.code == 'network-request-failed') {
        message = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
      }
      else {
        message = 'Lỗi đổi mật khẩu: ${e.message}';
      }
      _showSnackBar(message, Colors.red);
      debugPrint('Firebase Auth Error: ${e.message}');
    } catch (e) {
      _showSnackBar('Đổi mật khẩu thất bại: $e', Colors.red);
      debugPrint('General Change Password Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          message,
          color: Colors.white,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenLayout(
      appBar: AppBar(
        title: AppText(
          'Đổi mật khẩu',
          textStyle: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
            fontSize: 20.sp,
          ),
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                'Cập nhật mật khẩu của bạn',
                textStyle: textTheme.headlineMedium!.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
                color: Colors.black87,
              ),
              AppText(
                'Để bảo mật tài khoản, vui lòng nhập mật khẩu hiện tại và mật khẩu mới.',
                textStyle: textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                ),
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 32.h),
              AppTextField(
                controller: _currentPasswordController,
                label: 'Mật khẩu hiện tại',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _newPasswordController,
                label: 'Mật khẩu mới',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới.';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _confirmNewPasswordController,
                label: 'Xác nhận mật khẩu mới',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới.';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              AppButton(
                label: 'Đổi mật khẩu',
                onPressed: _changePassword,
                loading: _isLoading,
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
            ],
          ),
        ),
      ),
    );
  }
}