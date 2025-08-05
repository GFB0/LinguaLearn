import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SessionHeaderWidget extends StatelessWidget {
  final int currentCard;
  final int totalCards;
  final String difficultyLevel;
  final Duration sessionTime;
  final bool isPaused;
  final VoidCallback? onPausePressed;
  final double progress;

  const SessionHeaderWidget({
    super.key,
    required this.currentCard,
    required this.totalCards,
    required this.difficultyLevel,
    required this.sessionTime,
    this.isPaused = false,
    this.onPausePressed,
    required this.progress,
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress and card counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card counter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Cartão $currentCard de $totalCards',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Difficulty level
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getDifficultyIcon(),
                      color: _getDifficultyColor(),
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      difficultyLevel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _getDifficultyColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar and timer
          Row(
            children: [
              // Progress ring
              SizedBox(
                width: 12.w,
                height: 12.w,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 3,
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      color: _getProgressColor(),
                    ),
                    Center(
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Linear progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progresso da Sessão',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          colorScheme.outline.withValues(alpha: 0.2),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_getProgressColor()),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Timer and pause button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isPaused
                      ? AppTheme.warningLight.withValues(alpha: 0.1)
                      : colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isPaused ? 'pause_circle' : 'timer',
                      color: isPaused
                          ? AppTheme.warningLight
                          : colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatDuration(sessionTime),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isPaused
                            ? AppTheme.warningLight
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (onPausePressed != null) ...[
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: onPausePressed,
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: isPaused
                                ? AppTheme.successLight
                                : AppTheme.warningLight,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: isPaused ? 'play_arrow' : 'pause',
                            color: Colors.white,
                            size: 3.w,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (difficultyLevel.toLowerCase()) {
      case 'iniciante':
        return AppTheme.successLight;
      case 'intermediário':
        return AppTheme.warningLight;
      case 'avançado':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getDifficultyIcon() {
    switch (difficultyLevel.toLowerCase()) {
      case 'iniciante':
        return 'trending_up';
      case 'intermediário':
        return 'show_chart';
      case 'avançado':
        return 'trending_flat';
      default:
        return 'star';
    }
  }

  Color _getProgressColor() {
    if (progress < 0.3) {
      return AppTheme.errorLight;
    } else if (progress < 0.7) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.successLight;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}