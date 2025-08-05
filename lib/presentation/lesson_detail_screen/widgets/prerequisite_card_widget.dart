import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrerequisiteCardWidget extends StatelessWidget {
  final String title;
  final String difficulty;
  final bool isCompleted;
  final double completionPercentage;
  final VoidCallback? onTap;

  const PrerequisiteCardWidget({
    super.key,
    required this.title,
    required this.difficulty,
    required this.isCompleted,
    required this.completionPercentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
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
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: isCompleted ? 'check' : 'lock',
                    size: 16,
                    color: isCompleted
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getDifficultyColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                difficulty,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _getDifficultyColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progresso',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${(completionPercentage * 100).toInt()}%',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: completionPercentage.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
