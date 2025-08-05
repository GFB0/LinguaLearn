import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartReviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviewWords;
  final VoidCallback onViewAll;

  const SmartReviewWidget({
    super.key,
    required this.reviewWords,
    required this.onViewAll,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.getAccentColor(true),
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Revisão Inteligente',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'Ver todas',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Palavras que precisam de reforço baseado no algoritmo de repetição espaçada',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          reviewWords.isEmpty
              ? _buildEmptyState(context)
              : SizedBox(
                  height: 12.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviewWords.length,
                    itemBuilder: (context, index) {
                      final word = reviewWords[index];
                      return _buildReviewCard(context, word);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> word) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final urgency = word['urgency'] as String;
    final urgencyColor = _getUrgencyColor(urgency);

    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgencyColor.withValues(alpha: 0.3),
          width: 1,
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  word['word'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: urgencyColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            word['translation'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: urgencyColor,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                word['nextReview'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: urgencyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
            iconName: 'check_circle_outline',
            color: AppTheme.getSuccessColor(true),
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'Parabéns! Nenhuma palavra precisa de revisão no momento.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'alta':
        return AppTheme.lightTheme.colorScheme.error;
      case 'média':
        return AppTheme.getWarningColor(true);
      case 'baixa':
        return AppTheme.getSuccessColor(true);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
