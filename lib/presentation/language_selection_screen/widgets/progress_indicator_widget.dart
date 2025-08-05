import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Progress bar
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep - 1;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  height: 0.8.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isCompleted || isCurrent
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 1.h),

          // Step indicator text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passo $currentStep de $totalSteps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((currentStep / totalSteps) * 100).round()}% concluído',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
