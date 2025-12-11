import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import '../../../widgets/common/app_text.dart'; // Import AppText

class OrderEmpty extends StatelessWidget {
  const OrderEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80.sp, // Sử dụng .sp cho kích thước icon
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h), // Sử dụng .h
          AppText( // Sử dụng AppText
            'Bạn chưa có đơn hàng nào.',
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),
            color: Colors.grey[600],
          ),
          SizedBox(height: 8.h), // Sử dụng .h
          AppText( // Sử dụng AppText
            'Hãy đặt món ngay để khám phá những món ăn ngon!',
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
            textAlign: TextAlign.center,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}