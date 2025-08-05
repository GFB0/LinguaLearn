import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationTap;

  const GreetingHeaderWidget({
    super.key,
    required this.userName,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, $userName!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Pronto para aprender hoje?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onNotificationTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notificações em breve!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'notifications_outlined',
                color: colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
