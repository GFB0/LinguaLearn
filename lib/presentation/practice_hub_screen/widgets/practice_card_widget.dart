import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PracticeCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String iconName;
  final String duration;
  final String difficulty;
  final String lastCompleted;
  final double accuracy;
  final int totalSessions;
  final String improvementTrend;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PracticeCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.iconName,
    required this.duration,
    required this.difficulty,
    required this.lastCompleted,
    required this.accuracy,
    required this.totalSessions,
    required this.improvementTrend,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
            width: 85.w,
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: colorScheme.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ]),
            child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: CustomIconWidget(
                                    iconName: iconName,
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 6.w))),
                        SizedBox(width: 3.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              SizedBox(height: 0.5.h),
                              Text(description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ])),
                      ]),
                      SizedBox(height: 2.h),
                      Row(children: [
                        _buildInfoChip(
                            context,
                            CustomIconWidget(iconName: 'schedule', size: 3.w),
                            duration),
                        SizedBox(width: 2.w),
                        _buildInfoChip(
                            context,
                            CustomIconWidget(
                                iconName: 'trending_up',
                                color: AppTheme.getSuccessColor(true),
                                size: 3.w),
                            difficulty),
                      ]),
                      SizedBox(height: 1.5.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Última vez: $lastCompleted',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: _getAccuracyColor(accuracy)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                    '${accuracy.toStringAsFixed(0)}% precisão',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: _getAccuracyColor(accuracy),
                                        fontWeight: FontWeight.w500))),
                          ]),
                    ]))));
  }

  Widget _buildInfoChip(BuildContext context, Widget icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
        decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          icon,
          SizedBox(width: 1.w),
          Text(text,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ]));
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) {
      return AppTheme.getSuccessColor(true);
    } else if (accuracy >= 60) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
