import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;
  final Function(int)? onBadgePressed;

  const AchievementBadgesWidget({
    super.key,
    required this.achievements,
    this.onBadgePressed,
  });

  @override
  State<AchievementBadgesWidget> createState() =>
      _AchievementBadgesWidgetState();
}

class _AchievementBadgesWidgetState extends State<AchievementBadgesWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.achievements.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'military_tech',
                  color: AppTheme.getAccentColor(true),
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Conquistas Recentes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Página de conquistas em breve!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    'Ver Todas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Badges List
          SizedBox(
            height: 18.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: widget.achievements.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                if (index < _scaleAnimations.length) {
                  return AnimatedBuilder(
                    animation: _scaleAnimations[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimations[index].value,
                        child: _buildBadgeCard(
                            context, widget.achievements[index], index),
                      );
                    },
                  );
                }
                return _buildBadgeCard(
                    context, widget.achievements[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(
      BuildContext context, Map<String, dynamic> achievement, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnlocked = achievement["isUnlocked"] as bool;

    return GestureDetector(
      onTap: () {
        if (widget.onBadgePressed != null) {
          widget.onBadgePressed!(index);
        } else {
          _showBadgeDetails(context, achievement);
        }
      },
      child: Container(
        width: 30.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? _getBadgeColor(achievement["category"] as String)
                    .withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked
                  ? _getBadgeColor(achievement["category"] as String)
                      .withValues(alpha: 0.1)
                  : colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Icon
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? _getBadgeColor(achievement["category"] as String)
                        .withValues(alpha: 0.1)
                    : colorScheme.outline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: _getBadgeIcon(achievement["category"] as String),
                    color: isUnlocked
                        ? _getBadgeColor(achievement["category"] as String)
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 28,
                  ),
                  if (!isUnlocked)
                    CustomIconWidget(
                      iconName: 'lock',
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      size: 16,
                    ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Badge Title
            Text(
              achievement["title"] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isUnlocked
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (isUnlocked && achievement["dateUnlocked"] != null) ...[
              SizedBox(height: 0.5.h),
              Text(
                _formatDate(achievement["dateUnlocked"] as DateTime),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getBadgeIcon(String category) {
    switch (category) {
      case 'streak':
        return 'local_fire_department';
      case 'lesson':
        return 'school';
      case 'vocabulary':
        return 'quiz';
      case 'pronunciation':
        return 'mic';
      case 'milestone':
        return 'emoji_events';
      default:
        return 'star';
    }
  }

  Color _getBadgeColor(String category) {
    switch (category) {
      case 'streak':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'lesson':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'vocabulary':
        return AppTheme.getAccentColor(true);
      case 'pronunciation':
        return AppTheme.getWarningColor(true);
      case 'milestone':
        return AppTheme.getSuccessColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Ontem';
    } else if (difference < 7) {
      return '${difference}d atrás';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  void _showBadgeDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement["title"] as String),
        content: Text(achievement["description"] as String),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
