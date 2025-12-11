import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/checkout_form.dart';
import 'widgets/checkout_summary.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';

import '../../widgets/common/app_text.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_screen_layout.dart';

enum PaymentMethod { COD, Online }

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.COD:
        return 'Thanh toán khi nhận hàng (COD)';
      case PaymentMethod.Online:
        return 'Thanh toán trực tuyến';
      default:
        return '';
    }
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  PaymentMethod _selectedPayment = PaymentMethod.COD;
  bool _isLoading = false;

  late bool _useSavedAddress;
  String? _savedUserAddress;

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    _savedUserAddress = userProvider.user?.address;
    _useSavedAddress = _savedUserAddress != null && _savedUserAddress!.isNotEmpty;
    if (_useSavedAddress) {
      _addressController.text = _savedUserAddress!;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    final cartProv = context.read<CartProvider>();

    if (user == null) {
      _showErrorSnackBar('Bạn cần đăng nhập để đặt hàng.');
      return;
    }

    if (cartProv.items.isEmpty) {
      _showErrorSnackBar('Giỏ hàng đang trống.');
      return;
    }

    final shippingAddress = _useSavedAddress ? (_savedUserAddress ?? '') : _addressController.text.trim();
    final note = _noteController.text.trim();

    if (shippingAddress.isEmpty) {
      _showErrorSnackBar('Vui lòng nhập địa chỉ giao hàng.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final counterRef = FirebaseDatabase.instance.ref('counters/orders');
      final newOrderNumber = await counterRef.runTransaction((Object? currentData) {
        int nextNumber = (currentData as int? ?? 1000) + 1;
        return Transaction.success(nextNumber);
      });

      if (!newOrderNumber.committed) {
        throw Exception('Không thể lấy được mã đơn hàng.');
      }

      final displayId = 'HD-${newOrderNumber.snapshot.value}';

      final order = Order(
        id: '',
        displayId: displayId,
        userId: user.uid,
        items: cartProv.items.values.toList(),
        totalAmount: cartProv.totalAmount,
        dateTime: DateTime.now(),
        shippingAddress: shippingAddress,
        note: note,
        paymentMethod: _selectedPayment.name,
      );

      final userOrdersRef = FirebaseDatabase.instance.ref().child('orders').child(user.uid);
      final newOrderRef = userOrdersRef.push();

      order.id = newOrderRef.key!;
      await newOrderRef.set(order.toMap());

      cartProv.clearCart();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: AppText('Đặt hàng thành công!'),
            // ✅ SỬA LẠI NỘI DUNG THÔNG BÁO
            content: AppText('Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ xử lý đơn hàng sớm nhất có thể.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
                child: AppText('Về trang chủ'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi đặt hàng: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();

    return AppScreenLayout(
      appBar: AppBar(
        title: AppText('Thanh Toán'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckoutForm(
              addressController: _addressController,
              noteController: _noteController,
              selectedPayment: _selectedPayment,
              onPaymentMethodChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPayment = value);
                }
              },
              savedUserAddress: _savedUserAddress,
              useSavedAddress: _useSavedAddress,
              onUseSavedAddressChanged: (value) {
                setState(() {
                  _useSavedAddress = value;
                  if (_useSavedAddress && _savedUserAddress != null) {
                    _addressController.text = _savedUserAddress!;
                  } else {
                    _addressController.clear();
                  }
                });
              },
            ),
            SizedBox(height: 24.h),
            CheckoutSummary(totalAmount: cartProv.totalAmount),
            SizedBox(height: 24.h),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppButton(
                    label: 'Đặt hàng ngay',
                    onPressed: _submitOrder,
                  ),
          ],
        ),
      ),
    );
  }
}
