import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final Map<String, dynamic> stats;

  const QuickStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Lessons Completed
          Expanded(
            child: _buildStatItem(
              context,
              icon: 'school',
              value: stats["lessonsCompleted"].toString(),
              label: 'Lições\nConcluídas',
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 8.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Words Learned
          Expanded(
            child: _buildStatItem(
              context,
              icon: 'quiz',
              value: stats["wordsLearned"].toString(),
              label: 'Palavras\nAprendidas',
              color: AppTheme.getAccentColor(true),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 8.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Speaking Time
          Expanded(
            child: _buildStatItem(
              context,
              icon: 'mic',
              value: '${stats["speakingTimeMinutes"]}min',
              label: 'Tempo de\nFala',
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Icon
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
        ),

        SizedBox(height: 1.h),

        // Value
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 0.5.h),

        // Label
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
