import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SessionSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> summaryData;
  final VoidCallback? onContinue;
  final VoidCallback? onRestart;
  final VoidCallback? onHome;

  const SessionSummaryWidget({
    super.key,
    required this.summaryData,
    this.onContinue,
    this.onRestart,
    this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final accuracy = (summaryData["accuracy"] as double? ?? 0.0);
    final newWords = (summaryData["newWords"] as int? ?? 0);
    final reviewWords = (summaryData["reviewWords"] as int? ?? 0);
    final totalTime = (summaryData["totalTime"] as Duration? ?? Duration.zero);

    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -4)),
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Handle bar
          Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2))),

          SizedBox(height: 4.h),

          // Celebration icon and title
          Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: _getAccuracyColor(accuracy).withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: CustomIconWidget(
                  iconName: _getAccuracyIcon(accuracy),
                  color: _getAccuracyColor(accuracy),
                  size: 12.w)),

          SizedBox(height: 2.h),

          Text(_getAccuracyTitle(accuracy),
              style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),

          SizedBox(height: 1.h),

          Text(_getAccuracyMessage(accuracy),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),

          SizedBox(height: 4.h),

          // Statistics cards
          Row(children: [
            Expanded(
                child: _buildStatCard(
                    context: context,
                    title: 'Precisão',
                    value: '${(accuracy * 100).round()}%',
                    icon: 'target',
                    color: _getAccuracyColor(accuracy))),
            SizedBox(width: 3.w),
            Expanded(
                child: _buildStatCard(
                    context: context,
                    title: 'Tempo Total',
                    value: _formatDuration(totalTime),
                    icon: 'timer',
                    color: AppTheme.lightTheme.primaryColor)),
          ]),

          SizedBox(height: 3.w),

          Row(children: [
            Expanded(
                child: _buildStatCard(
                    context: context,
                    title: 'Novas Palavras',
                    value: newWords.toString(),
                    icon: 'add_circle',
                    color: AppTheme.successLight)),
            SizedBox(width: 3.w),
            Expanded(
                child: _buildStatCard(
                    context: context,
                    title: 'Para Revisar',
                    value: reviewWords.toString(),
                    icon: 'refresh',
                    color: AppTheme.warningLight)),
          ]),

          SizedBox(height: 4.h),

          // Recommendations
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                      width: 1)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      CustomIconWidget(
                          iconName: 'lightbulb',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 5.w),
                      SizedBox(width: 2.w),
                      Text('Recomendações',
                          style: theme.textTheme.titleMedium?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600)),
                    ]),
                    SizedBox(height: 2.h),
                    ..._getRecommendations(accuracy, reviewWords).map((rec) =>
                        Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme.successLight,
                                      size: 4.w),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                      child: Text(rec,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color:
                                                      colorScheme.onSurface))),
                                ]))),
                  ])),

          SizedBox(height: 4.h),

          // Action buttons
          Column(children: [
            // Continue button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: onContinue,
                    icon: CustomIconWidget(
                        iconName: 'play_arrow', color: Colors.white, size: 5.w),
                    label: Text('Continuar Estudando'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))))),

            SizedBox(height: 2.h),

            // Secondary actions
            Row(children: [
              Expanded(
                  child: OutlinedButton.icon(
                      onPressed: onRestart,
                      icon: CustomIconWidget(iconName: 'refresh', size: 4.w),
                      label: Text('Repetir'),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))))),
              SizedBox(width: 3.w),
              Expanded(
                  child: TextButton.icon(
                      onPressed: onHome,
                      icon: CustomIconWidget(
                          iconName: 'home',
                          color: colorScheme.onSurfaceVariant,
                          size: 4.w),
                      label: Text('Início'),
                      style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))))),
            ]),
          ]),

          SizedBox(height: 2.h),
        ]));
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1)),
        child: Column(children: [
          CustomIconWidget(iconName: icon, color: color, size: 6.w),
          SizedBox(height: 1.h),
          Text(value,
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: color, fontWeight: FontWeight.w700)),
          Text(title,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),
        ]));
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return AppTheme.successLight;
    if (accuracy >= 0.6) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String _getAccuracyIcon(double accuracy) {
    if (accuracy >= 0.8) return 'emoji_events';
    if (accuracy >= 0.6) return 'thumb_up';
    return 'trending_up';
  }

  String _getAccuracyTitle(double accuracy) {
    if (accuracy >= 0.8) return 'Excelente trabalho!';
    if (accuracy >= 0.6) return 'Bom progresso!';
    return 'Continue praticando!';
  }

  String _getAccuracyMessage(double accuracy) {
    if (accuracy >= 0.8) return 'Você dominou essas palavras com maestria.';
    if (accuracy >= 0.6)
      return 'Você está no caminho certo para dominar o vocabulário.';
    return 'A prática leva à perfeição. Continue se esforçando!';
  }

  List<String> _getRecommendations(double accuracy, int reviewWords) {
    List<String> recommendations = [];

    if (accuracy < 0.6) {
      recommendations.add('Pratique as palavras difíceis com mais frequência');
      recommendations.add('Use as dicas quando necessário');
    }

    if (reviewWords > 5) {
      recommendations
          .add('Revise as palavras marcadas antes da próxima sessão');
    }

    if (accuracy >= 0.8) {
      recommendations.add('Experimente palavras de nível mais avançado');
      recommendations.add('Pratique a pronúncia dessas palavras');
    }

    recommendations.add('Mantenha uma rotina diária de estudo');

    return recommendations;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
