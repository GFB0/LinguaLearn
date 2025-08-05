import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentPracticeWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentPractices;

  const RecentPracticeWidget({
    super.key,
    required this.recentPractices,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Praticado Recentemente',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          recentPractices.isEmpty
              ? _buildEmptyState(context)
              : SizedBox(
                  height: 15.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentPractices.length,
                    itemBuilder: (context, index) {
                      final practice = recentPractices[index];
                      return _buildPracticeCard(context, practice);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(
      BuildContext context, Map<String, dynamic> practice) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final score = practice['score'] as double;

    return Container(
      width: 45.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: practice['iconName'] as String,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  practice['title'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            practice['date'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(context, practice['badge'] as String),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getScoreColor(score).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${score.toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getScoreColor(score),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String badge) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    String badgeIcon;

    switch (badge.toLowerCase()) {
      case 'perfeito':
        badgeColor = AppTheme.getSuccessColor(true);
        badgeIcon = 'star';
        break;
      case 'excelente':
        badgeColor = AppTheme.lightTheme.primaryColor;
        badgeIcon = 'thumb_up';
        break;
      case 'bom':
        badgeColor = AppTheme.getWarningColor(true);
        badgeIcon = 'trending_up';
        break;
      default:
        badgeColor = colorScheme.onSurfaceVariant;
        badgeIcon = 'circle';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: badgeIcon,
            color: badgeColor,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            badge,
            style: theme.textTheme.bodySmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'play_circle_outline',
            color: colorScheme.onSurfaceVariant,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'Comece a praticar para ver seu histórico aqui!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) {
      return AppTheme.getSuccessColor(true);
    } else if (score >= 70) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
