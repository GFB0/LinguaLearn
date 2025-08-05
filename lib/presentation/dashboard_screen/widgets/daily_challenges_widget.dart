import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyChallengesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> challenges;
  final Function(int)? onChallengePressed;

  const DailyChallengesWidget({
    super.key,
    required this.challenges,
    this.onChallengePressed,
  });

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
                  iconName: 'emoji_events',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Desafios Diários',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Challenges List
          SizedBox(
            height: 25.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: challenges.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return _buildChallengeCard(context, challenge, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
      BuildContext context, Map<String, dynamic> challenge, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = (challenge["progress"] as double) >= 1.0;

    return GestureDetector(
      onTap: () {
        if (onChallengePressed != null) {
          onChallengePressed!(index);
        } else {
          _navigateToChallenge(context, challenge["type"] as String);
        }
      },
      child: Container(
        width: 45.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge Icon
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getChallengeColor(challenge["type"] as String)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _getChallengeIcon(challenge["type"] as String),
                color: _getChallengeColor(challenge["type"] as String),
                size: 24,
              ),
            ),

            SizedBox(height: 2.h),

            // Challenge Title
            Text(
              challenge["title"] as String,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 1.h),

            // Challenge Description
            Text(
              challenge["description"] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Progress Bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (challenge["progress"] as double).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _getChallengeColor(challenge["type"] as String),
                  ),
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // XP Reward
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'stars',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '+${challenge["xpReward"]} XP',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.getSuccessColor(true),
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getChallengeIcon(String type) {
    switch (type) {
      case 'vocabulary':
        return 'quiz';
      case 'pronunciation':
        return 'mic';
      case 'grammar':
        return 'menu_book';
      default:
        return 'star';
    }
  }

  Color _getChallengeColor(String type) {
    switch (type) {
      case 'vocabulary':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'pronunciation':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'grammar':
        return AppTheme.getAccentColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _navigateToChallenge(BuildContext context, String type) {
    switch (type) {
      case 'vocabulary':
        Navigator.pushNamed(context, '/vocabulary-flashcards-screen');
        break;
      case 'pronunciation':
      case 'grammar':
        Navigator.pushNamed(context, '/practice-hub-screen');
        break;
      default:
        Navigator.pushNamed(context, '/practice-hub-screen');
    }
  }
}
