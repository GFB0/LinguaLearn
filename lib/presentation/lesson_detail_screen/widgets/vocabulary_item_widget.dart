import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VocabularyItemWidget extends StatefulWidget {
  final String word;
  final String translation;
  final String pronunciation;
  final String example;
  final VoidCallback? onPlayAudio;

  const VocabularyItemWidget({
    super.key,
    required this.word,
    required this.translation,
    required this.pronunciation,
    required this.example,
    this.onPlayAudio,
  });

  @override
  State<VocabularyItemWidget> createState() => _VocabularyItemWidgetState();
}

class _VocabularyItemWidgetState extends State<VocabularyItemWidget> {
  bool _isPlaying = false;

  void _handlePlayAudio() {
    setState(() {
      _isPlaying = true;
    });

    widget.onPlayAudio?.call();

    // Simulate audio playback duration
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
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
                      widget.word,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.pronunciation,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _handlePlayAudio,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _isPlaying
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isPlaying
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'volume_up',
                          size: 20,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tradução:',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.translation,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Exemplo:',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.example,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
