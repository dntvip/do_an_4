import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../widgets/common/app_screen_layout.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/network_image_with_loader.dart';

// Import widget con cho form fields
import 'widgets/edit_profile_form_fields.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;
  bool _isDataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ CHỈ KHỞI TẠO DỮ LIỆU MỘT LẦN DUY NHẤT
    if (!_isDataInitialized) {
      final user = context.read<UserProvider>().user;
      if (user != null) {
        _nameController.text = user.name ?? '';
        _phoneController.text = user.phoneNumber ?? '';
        _addressController.text = user.address ?? '';
      }
      _isDataInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    // Kiểm tra tính hợp lệ của form trước khi lưu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user?.uid;

    if (userId == null) {
      _showSnackBar('Không thể xác thực người dùng. Vui lòng thử lại.', Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Gọi hàm updateUserProfile từ UserProvider
      await userProvider.updateUserProfile(
        userId: userId,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (mounted) {
        _showSnackBar('Cập nhật thông tin thành công!', Colors.green);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Cập nhật thông tin thất bại: $e', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
    // Lấy avatarUrl từ provider
    final avatarUrl = context.watch<UserProvider>().user?.avatarUrl;

    return AppScreenLayout(
      appBar: AppBar(
        title: AppText('Chỉnh sửa thông tin'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                // Widget hiển thị ảnh đại diện
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.grey.shade200,
                  child: NetworkImageWithLoader(
                    imageUrl: avatarUrl,
                    width: 120.r,
                    height: 120.r,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              EditProfileFormFields(
                nameController: _nameController,
                phoneController: _phoneController,
                addressController: _addressController,
              ),
              SizedBox(height: 40.h),
              AppButton(
                label: 'Lưu Thay Đổi',
                onPressed: _saveProfile,
                loading: _isLoading,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  textStyle: textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
