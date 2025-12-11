import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_screen_layout.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  // ✅ SỬ DỤNG CÚ PHÁP CŨ VÀ ỔN ĐỊNH
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String message = (e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password')
          ? 'Email hoặc mật khẩu không chính xác.'
          : 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      _showErrorSnackBar(message);
    } catch (e) {
      _showErrorSnackBar('Đã xảy ra lỗi không mong muốn.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() => _isGoogleLoading = false);
        return; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (mounted) Navigator.of(context).pop();
      
    } catch (e) {
      _showErrorSnackBar('Lỗi đăng nhập với Google. Vui lòng thử lại.');
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(message, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenLayout(
      appBar: AppBar(title: AppText('Đăng nhập')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeader(
                title: 'Cơm Nhà Nấu!',
                subtitle: 'Đăng nhập để tiếp tục',
                icon: Icons.fastfood,
              ),
              SizedBox(height: 32.h),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                 validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email không hợp lệ.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _passwordController,
                label: 'Mật khẩu',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (value) => (value?.isEmpty ?? true) ? 'Vui lòng nhập mật khẩu.' : null,
              ),
              SizedBox(height: 24.h),
              AppButton(
                label: 'Đăng Nhập',
                onPressed: _login,
                loading: _isLoading,
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: AppText(
                  'Chưa có tài khoản? Đăng ký',
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: AppText('HOẶC', color: Colors.grey.shade600),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20.h),
              AppButton(
                label: 'Đăng nhập với Google',
                onPressed: _signInWithGoogle,
                loading: _isGoogleLoading,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
