import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContinueLearningCardWidget extends StatelessWidget {
  final Map<String, dynamic> currentLesson;
  final VoidCallback? onPlayPressed;

  const ContinueLearningCardWidget({
    super.key,
    required this.currentLesson,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'play_circle_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Continuar Aprendendo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Lesson Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                // Lesson Thumbnail
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: currentLesson["thumbnail"] as String,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Lesson Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLesson["title"] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${currentLesson["estimatedTime"]} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Progress Bar
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (currentLesson["progress"] as double)
                              .clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Play Button
                GestureDetector(
                  onTap: onPlayPressed ??
                      () {
                        Navigator.pushNamed(context, '/lesson-detail-screen');
                      },
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.w),
        ],
      ),
    );
  }
}
