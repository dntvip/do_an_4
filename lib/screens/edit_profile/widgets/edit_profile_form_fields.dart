import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_text_field.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const EditProfileFormFields({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Họ và tên',
          textStyle: textTheme.bodyLarge!.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          controller: nameController,
          label: 'Họ và tên',
          hintText: 'Nhập họ và tên của bạn',
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 20.h),
        AppText(
          'Số điện thoại',
          textStyle: textTheme.bodyLarge!.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          controller: phoneController,
          label: 'Số điện thoại',
          hintText: 'Nhập số điện thoại của bạn',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20.h),
        AppText(
          'Địa chỉ',
          textStyle: textTheme.bodyLarge!.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          controller: addressController,
          label: 'Địa chỉ',
          hintText: 'Nhập địa chỉ của bạn',
          keyboardType: TextInputType.streetAddress,
          maxLines: 3,
        ),
      ],
    );
  }
}