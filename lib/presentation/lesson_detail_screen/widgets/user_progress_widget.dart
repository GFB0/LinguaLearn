import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserProgressWidget extends StatelessWidget {
  final List<Map<String, dynamic>> attempts;
  final int totalTimeSpent;
  final double averageScore;

  const UserProgressWidget({
    super.key,
    required this.attempts,
    required this.totalTimeSpent,
    required this.averageScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu Progresso',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Tentativas',
                  attempts.length.toString(),
                  Icons.refresh,
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Tempo Total',
                  '${totalTimeSpent}min',
                  Icons.access_time,
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Média',
                  '${(averageScore * 100).toInt()}%',
                  Icons.trending_up,
                  const Color(0xFF27AE60),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Histórico de Pontuações',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 200,
            child: Semantics(
              label: "Gráfico de Histórico de Pontuações",
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() < attempts.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${value.toInt() + 1}',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  minX: 0,
                  maxX: (attempts.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: attempts.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          ((entry.value['score'] as double) * 100),
                        );
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Últimas Tentativas',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attempts.take(3).length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final attempt = attempts[index];
              return _buildAttemptItem(attempt);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            size: 24,
            color: color,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptItem(Map<String, dynamic> attempt) {
    final score = (attempt['score'] as double) * 100;
    final date = attempt['date'] as DateTime;
    final timeSpent = attempt['timeSpent'] as int;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getScoreColor(score).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: score >= 80
                  ? 'emoji_events'
                  : score >= 60
                      ? 'thumb_up'
                      : 'refresh',
              size: 20,
              color: _getScoreColor(score),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${score.toInt()}% - ${_getScoreLabel(score)}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${date.day}/${date.month}/${date.year} • ${timeSpent}min',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF27AE60);
    if (score >= 60) return const Color(0xFFF39C12);
    return const Color(0xFFE74C3C);
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excelente';
    if (score >= 60) return 'Bom';
    return 'Precisa Melhorar';
  }
}
