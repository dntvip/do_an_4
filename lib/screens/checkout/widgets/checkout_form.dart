import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/common/app_text_field.dart';
import '../../../widgets/common/app_text.dart';

// ✅ BƯỚC 1: IMPORT FILE CHỨA ENUM
import '../checkout_screen.dart';

class CheckoutForm extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController noteController;
  
  // ✅ BƯỚC 2: THAY ĐỔI KIỂU DỮ LIỆU CỦA CÁC THAM SỐ
  final PaymentMethod selectedPayment;
  final ValueChanged<PaymentMethod?> onPaymentMethodChanged;
  
  final String? savedUserAddress;
  final bool useSavedAddress;
  final ValueChanged<bool> onUseSavedAddressChanged;

  const CheckoutForm({
    super.key,
    required this.addressController,
    required this.noteController,
    required this.selectedPayment,
    required this.onPaymentMethodChanged,
    this.savedUserAddress,
    required this.useSavedAddress,
    required this.onUseSavedAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Địa chỉ giao hàng:',
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),

        if (savedUserAddress != null && savedUserAddress!.isNotEmpty)
          Column(
            children: [
              RadioListTile<bool>(
                title: const AppText('Sử dụng địa chỉ đã lưu:'),
                subtitle: AppText(savedUserAddress!),
                value: true,
                groupValue: useSavedAddress,
                onChanged: (value) => onUseSavedAddressChanged(value ?? true),
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<bool>(
                title: const AppText('Nhập địa chỉ mới:'),
                value: false,
                groupValue: useSavedAddress,
                onChanged: (value) => onUseSavedAddressChanged(value ?? false),
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: 16.h),
            ],
          ),

        if (!useSavedAddress || savedUserAddress == null || savedUserAddress!.isEmpty)
          AppTextField(
            controller: addressController,
            label: 'Địa chỉ giao hàng',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
        SizedBox(height: 16.h),

        AppTextField(
          controller: noteController,
          label: 'Ghi chú (nếu có)',
          icon: Icons.notes_outlined,
          maxLines: 2,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppText(
                'Phương thức thanh toán:',
                textStyle: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 4,
              child: DropdownButton<PaymentMethod>(
                value: selectedPayment,
                onChanged: onPaymentMethodChanged,
                isExpanded: true,
                // ✅ BƯỚC 3: TẠO CÁC DROPDOWNMENUITEM TỪ ENUM
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: AppText(
                      method.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                dropdownColor: colorScheme.surface,
                style: Theme.of(context).textTheme.bodyMedium,
                iconEnabledColor: colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
