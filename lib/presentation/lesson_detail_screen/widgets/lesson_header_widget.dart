import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LessonHeaderWidget extends StatelessWidget {
  final String title;
  final String difficulty;
  final String duration;
  final double completionPercentage;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;

  const LessonHeaderWidget({
    super.key,
    required this.title,
    required this.difficulty,
    required this.duration,
    required this.completionPercentage,
    this.isBookmarked = false,
    this.onBookmarkTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            difficulty,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: _getDifficultyColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: 'access_time',
                          size: 16,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          duration,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onBookmarkTap,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isBookmarked
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
                        size: 24,
                        color: isBookmarked
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: onShareTap,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        size: 24,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso da Lição',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${(completionPercentage * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: completionPercentage.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'iniciante':
        return const Color(0xFF27AE60);
      case 'intermediário':
        return const Color(0xFFF39C12);
      case 'avançado':
        return const Color(0xFFE74C3C);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
