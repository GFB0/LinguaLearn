import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeeklyChallengeWidget extends StatelessWidget {
  final String challengeTitle;
  final String challengeDescription;
  final int currentProgress;
  final int targetProgress;
  final int userRank;
  final int totalParticipants;
  final VoidCallback onViewLeaderboard;
  final VoidCallback onJoinChallenge;

  const WeeklyChallengeWidget({
    super.key,
    required this.challengeTitle,
    required this.challengeDescription,
    required this.currentProgress,
    required this.targetProgress,
    required this.userRank,
    required this.totalParticipants,
    required this.onViewLeaderboard,
    required this.onJoinChallenge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressPercentage =
        (currentProgress / targetProgress).clamp(0.0, 1.0);

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colorScheme.secondary,
              colorScheme.secondary.withValues(alpha: 0.8),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 12, offset: const Offset(0, 4)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: CustomIconWidget(
                        iconName: 'emoji_events',
                        color: Colors.white,
                        size: 6.w))),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Desafio da Semana',
                      style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500)),
                  Text(challengeTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ])),
          ]),
          SizedBox(height: 2.h),
          Text(challengeDescription,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 2.h),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progresso',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8))),
                        Text('$currentProgress/$targetProgress',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ]),
                  SizedBox(height: 1.h),
                  Container(
                      height: 1.h,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4)),
                      child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progressPercentage,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4))))),
                ])),
            SizedBox(width: 4.w),
            Column(children: [
              Text('#$userRank',
                  style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              Text('de $totalParticipants',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
            ]),
          ]),
          SizedBox(height: 2.h),
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: onJoinChallenge,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                        currentProgress > 0 ? 'Continuar' : 'Participar',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)))),
            SizedBox(width: 3.w),
            OutlinedButton(
                onPressed: onViewLeaderboard,
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CustomIconWidget(
                      iconName: 'leaderboard', color: Colors.white, size: 4.w),
                  SizedBox(width: 1.w),
                  Text('Ranking',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ])),
          ]),
        ]));
  }
}