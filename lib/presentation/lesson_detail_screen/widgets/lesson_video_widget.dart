import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LessonVideoWidget extends StatefulWidget {
  final String videoThumbnail;
  final String videoTitle;
  final String videoDuration;
  final VoidCallback? onPlayTap;

  const LessonVideoWidget({
    super.key,
    required this.videoThumbnail,
    required this.videoTitle,
    required this.videoDuration,
    this.onPlayTap,
  });

  @override
  State<LessonVideoWidget> createState() => _LessonVideoWidgetState();
}

class _LessonVideoWidgetState extends State<LessonVideoWidget> {
  bool _isMuted = false;
  double _volume = 0.8;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CustomImageWidget(
                imageUrl: widget.videoThumbnail,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Play button overlay
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                child: GestureDetector(
                  onTap: widget.onPlayTap,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      size: 10.w,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Volume controls
            Positioned(
              top: 2.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                      child: CustomIconWidget(
                        iconName: _isMuted ? 'volume_off' : 'volume_up',
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    SizedBox(
                      width: 15.w,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 12),
                        ),
                        child: Slider(
                          value: _isMuted ? 0 : _volume,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                              _isMuted = value == 0;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Video info overlay
            Positioned(
              bottom: 2.h,
              left: 4.w,
              right: 4.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.videoTitle,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        widget.videoDuration,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
