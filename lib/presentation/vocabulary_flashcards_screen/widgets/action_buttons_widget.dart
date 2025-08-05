import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onKnowIt;
  final VoidCallback? onReviewAgain;
  final VoidCallback? onSkip;
  final VoidCallback? onHint;
  final bool showHint;
  final bool isEnabled;

  const ActionButtonsWidget({
    super.key,
    this.onKnowIt,
    this.onReviewAgain,
    this.onSkip,
    this.onHint,
    this.showHint = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hint button (appears on double tap)
          if (showHint)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 2.h),
              child: OutlinedButton.icon(
                onPressed: isEnabled
                    ? () {
                        HapticFeedback.selectionClick();
                        onHint?.call();
                      }
                    : null,
                icon: CustomIconWidget(
                  iconName: 'lightbulb_outline',
                  color: AppTheme.warningLight,
                  size: 5.w,
                ),
                label: Text('Mostrar Dica'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.warningLight,
                  side: BorderSide(color: AppTheme.warningLight, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          // Main action buttons
          Row(
            children: [
              // Review Again (Left swipe alternative)
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Revisar',
                  icon: 'refresh',
                  color: AppTheme.errorLight,
                  onPressed: isEnabled
                      ? () {
                          HapticFeedback.lightImpact();
                          onReviewAgain?.call();
                        }
                      : null,
                ),
              ),

              SizedBox(width: 3.w),

              // Skip button
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Pular',
                  icon: 'skip_next',
                  color: colorScheme.onSurfaceVariant,
                  onPressed: isEnabled
                      ? () {
                          HapticFeedback.selectionClick();
                          onSkip?.call();
                        }
                      : null,
                  isOutlined: true,
                ),
              ),

              SizedBox(width: 3.w),

              // Know It (Right swipe alternative)
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Sei',
                  icon: 'check_circle',
                  color: AppTheme.successLight,
                  onPressed: isEnabled
                      ? () {
                          HapticFeedback.lightImpact();
                          onKnowIt?.call();
                        }
                      : null,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Accessibility instructions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'swipe',
                  color: colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Deslize ou toque nos botões para navegar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required String icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isOutlined = false,
  }) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: CustomIconWidget(
          iconName: icon,
          color: color,
          size: 5.w,
        ),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.5), width: 1),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: icon,
        color: Colors.white,
        size: 5.w,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
