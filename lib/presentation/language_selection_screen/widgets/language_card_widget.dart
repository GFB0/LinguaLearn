import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LanguageCardWidget extends StatelessWidget {
  final Map<String, dynamic> language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCardWidget({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flag and difficulty indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 12.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(language["flagUrl"] as String),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                                  language["difficulty"] as String, colorScheme)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          language["difficulty"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getDifficultyColor(
                                language["difficulty"] as String, colorScheme),
                            fontWeight: FontWeight.w500,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Language name in Portuguese
                  Text(
                    language["namePortuguese"] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),

                  // Language name in native script
                  Text(
                    language["nameNative"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),

                  // Lessons count and completion time
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'book_outlined',
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          '${language["lessonsCount"]} lições',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          language["estimatedTime"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Selection checkmark overlay
            if (isSelected)
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty, ColorScheme colorScheme) {
    switch (difficulty.toLowerCase()) {
      case 'iniciante':
        return const Color(0xFF27AE60); // Success green
      case 'intermediário':
        return const Color(0xFFF39C12); // Warning orange
      case 'avançado':
        return const Color(0xFFE74C3C); // Error red
      default:
        return colorScheme.primary;
    }
  }
}
