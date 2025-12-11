import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../widgets/common/app_text.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = context.watch<UserProvider>().user;

    if (currentUser == null) {
      return Container(height: 120.h, color: colorScheme.primary);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 38.r,
              backgroundImage: currentUser.avatarUrl != null && currentUser.avatarUrl!.isNotEmpty
                  ? NetworkImage(currentUser.avatarUrl!)
                  : null,
              child: currentUser.avatarUrl == null || currentUser.avatarUrl!.isEmpty
                  ? Icon(Icons.person, size: 38.sp, color: Colors.grey)
                  : null,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  currentUser.name ?? 'Chưa cập nhật',
                  textStyle: Theme.of(context).textTheme.titleLarge,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16.sp, color: Colors.white70),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AppText(
                        currentUser.phoneNumber?.isNotEmpty == true ? currentUser.phoneNumber! : 'Chưa có SĐT',
                        color: Colors.white70,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: Colors.white70),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AppText(
                        currentUser.address?.isNotEmpty == true ? currentUser.address! : 'Chưa có địa chỉ',
                        color: Colors.white70,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
