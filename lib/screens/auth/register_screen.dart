import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../address/mapbox_screen.dart'; // Import the map screen
import '../../models/user_model.dart';
import '../../widgets/common/app_screen_layout.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user!;

      final newAppUser = AppUser(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
      await usersRef.child(newAppUser.uid).set(newAppUser.toMap());

      if (mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Đăng ký thành công!'),
            content: const Text('Tài khoản của bạn đã được tạo. Vui lòng đăng nhập để tiếp tục.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (mounted) Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = (e.code == 'weak-password')
          ? 'Mật khẩu quá yếu.'
          : (e.code == 'email-already-in-use')
              ? 'Email này đã được sử dụng.'
              : 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      _showSnackBar(message, Colors.red);
    } catch (e) {
      _showSnackBar('Đã có lỗi không mong muốn: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(message, color: Colors.white),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenLayout(
      appBar: AppBar(title: AppText('Đăng ký')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                'Tạo tài khoản',
                textStyle: textTheme.headlineMedium,
                color: Colors.black87,
              ),
              SizedBox(height: 32.h),
              AppTextField(
                controller: _nameController,
                label: 'Họ tên',
                icon: Icons.person_outline,
                validator: (value) => (value?.isEmpty ?? true) ? 'Vui lòng nhập họ tên.' : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng nhập email.';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Email không hợp lệ.';
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _phoneController,
                label: 'Số điện thoại',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.isEmpty ?? true) ? 'Vui lòng nhập số điện thoại.' : null,
              ),
              SizedBox(height: 16.h),
              // --- MODIFIED ADDRESS FIELD ---
              GestureDetector(
                onTap: () async {
                  final selectedAddress = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(builder: (context) => const MapboxScreen()),
                  );
                  if (selectedAddress != null) {
                    setState(() {
                      _addressController.text = selectedAddress;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: AppTextField(
                    controller: _addressController,
                    label: 'Địa chỉ',
                    icon: Icons.home_outlined,
                    validator: (value) => (value?.isEmpty ?? true) ? 'Vui lòng chọn địa chỉ.' : null,
                  ),
                ),
              ),
              // --- END MODIFIED ADDRESS FIELD ---
              SizedBox(height: 16.h),
              AppTextField(
                controller: _passwordController,
                label: 'Mật khẩu',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (value) => (value?.length ?? 0) < 6 ? 'Mật khẩu phải có ít nhất 6 ký tự.' : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _confirmPasswordController,
                label: 'Xác nhận mật khẩu',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (value) {
                  if (value != _passwordController.text) return 'Mật khẩu không khớp.';
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              AppButton(
                label: 'Đăng Ký',
                onPressed: _register,
                loading: _isLoading,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText('Bạn đã có tài khoản?', textStyle: textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: AppText(
                      'Đăng nhập',
                      textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
