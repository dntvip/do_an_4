import 'package:flutter/material.dart';
import '../../themes/app_theme.dart'; // Đảm bảo import đúng đường dẫn theme của bạn

class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.star, // Mặc định một icon chung nếu không truyền vào
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 64,
          color: iconColor ?? theme.colorScheme.primary, // Dùng màu primary từ theme
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary, // Dùng màu primary từ theme
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}