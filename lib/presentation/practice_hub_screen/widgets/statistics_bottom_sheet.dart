import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsBottomSheet extends StatefulWidget {
  const StatisticsBottomSheet({super.key});

  @override
  State<StatisticsBottomSheet> createState() => _StatisticsBottomSheetState();
}

class _StatisticsBottomSheetState extends State<StatisticsBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> weeklyData = [
    {'day': 'Seg', 'minutes': 25, 'accuracy': 85},
    {'day': 'Ter', 'minutes': 30, 'accuracy': 92},
    {'day': 'Qua', 'minutes': 20, 'accuracy': 78},
    {'day': 'Qui', 'minutes': 35, 'accuracy': 88},
    {'day': 'Sex', 'minutes': 40, 'accuracy': 95},
    {'day': 'Sáb', 'minutes': 15, 'accuracy': 82},
    {'day': 'Dom', 'minutes': 28, 'accuracy': 90},
  ];

  final List<Map<String, dynamic>> skillsData = [
    {
      'skill': 'Vocabulário',
      'progress': 85,
      'color': AppTheme.lightTheme.primaryColor
    },
    {
      'skill': 'Gramática',
      'progress': 72,
      'color': AppTheme.lightTheme.colorScheme.secondary
    },
    {
      'skill': 'Pronúncia',
      'progress': 68,
      'color': AppTheme.getAccentColor(true)
    },
    {
      'skill': 'Escuta',
      'progress': 79,
      'color': AppTheme.getSuccessColor(true)
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          Container(
              padding: EdgeInsets.all(4.w),
              child: Column(children: [
                Center(
                    child: Container(
                        width: 10.w,
                        height: 0.5.h,
                        decoration: BoxDecoration(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2)))),
                SizedBox(height: 2.h),
                Row(children: [
                  CustomIconWidget(
                      iconName: 'analytics',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w),
                  SizedBox(width: 2.w),
                  Text('Estatísticas Detalhadas',
                      style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface)),
                ]),
                SizedBox(height: 2.h),
                TabBar(controller: _tabController, tabs: const [
                  Tab(text: 'Semanal'),
                  Tab(text: 'Habilidades'),
                  Tab(text: 'Sugestões'),
                ]),
              ])),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            _buildWeeklyTab(context),
            _buildSkillsTab(context),
            _buildSuggestionsTab(context),
          ])),
        ]));
  }

  Widget _buildWeeklyTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tempo de Prática (minutos)',
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          SizedBox(height: 2.h),
          Container(
              height: 30.h,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12)),
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < weeklyData.length) {
                                  return Text(
                                      weeklyData[value.toInt()]['day']
                                          as String,
                                      style: theme.textTheme.bodySmall);
                                }
                                return const Text('');
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 8.w,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(),
                                    style: theme.textTheme.bodySmall);
                              })),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  borderData: FlBorderData(show: false),
                  barGroups: weeklyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: (data['minutes'] as int).toDouble(),
                          color: AppTheme.lightTheme.primaryColor,
                          width: 4.w,
                          borderRadius: BorderRadius.circular(2)),
                    ]);
                  }).toList()))),
          SizedBox(height: 3.h),
          Text('Precisão (%)',
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          SizedBox(height: 2.h),
          Container(
              height: 25.h,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12)),
              child: LineChart(LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < weeklyData.length) {
                                  return Text(
                                      weeklyData[value.toInt()]['day']
                                          as String,
                                      style: theme.textTheme.bodySmall);
                                }
                                return const Text('');
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 8.w,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%',
                                    style: theme.textTheme.bodySmall);
                              })),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (weeklyData.length - 1).toDouble(),
                  minY: 60,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                        spots: weeklyData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          return FlSpot(index.toDouble(),
                              (data['accuracy'] as int).toDouble());
                        }).toList(),
                        isCurved: true,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  strokeWidth: 2,
                                  strokeColor: colorScheme.surface);
                            }),
                        belowBarData: BarAreaData(show: true)),
                  ]))),
        ]));
  }

  Widget _buildSkillsTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Progresso por Habilidade',
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          SizedBox(height: 2.h),
          ...skillsData.map((skill) => _buildSkillProgressCard(context, skill)),
          SizedBox(height: 3.h),
          Text('Distribuição de Tempo',
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          SizedBox(height: 2.h),
          Container(
              height: 30.h,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12)),
              child: PieChart(PieChartData(
                  sections: skillsData.map((skill) {
                    return PieChartSectionData(
                        color: skill['color'] as Color,
                        value: (skill['progress'] as int).toDouble(),
                        title: '${skill['progress']}%',
                        radius: 15.w,
                        titleStyle: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600));
                  }).toList(),
                  centerSpaceRadius: 8.w,
                  sectionsSpace: 2))),
        ]));
  }

  Widget _buildSkillProgressCard(
      BuildContext context, Map<String, dynamic> skill) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = skill['progress'] as int;
    final color = skill['color'] as Color;

    return Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(skill['skill'] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            Text('$progress%',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600, color: color)),
          ]),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 1.h),
        ]));
  }

  Widget _buildSuggestionsTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final suggestions = [
      {
        'title': 'Foque na Pronúncia',
        'description':
            'Sua precisão em pronúncia está 15% abaixo da média. Pratique 10 minutos extras por dia.',
        'iconName': 'mic',
        'priority': 'alta',
      },
      {
        'title': 'Mantenha a Consistência',
        'description':
            'Você está indo bem! Continue praticando diariamente para manter o progresso.',
        'iconName': 'trending_up',
        'priority': 'média',
      },
      {
        'title': 'Explore Gramática Avançada',
        'description':
            'Você dominou o básico. Hora de avançar para estruturas mais complexas.',
        'iconName': 'auto_fix_high',
        'priority': 'baixa',
      },
      {
        'title': 'Diversifique o Vocabulário',
        'description':
            'Adicione palavras de diferentes categorias para expandir seu conhecimento.',
        'iconName': 'library_books',
        'priority': 'média',
      },
    ];

    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Sugestões Personalizadas',
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          SizedBox(height: 1.h),
          Text('Baseado na sua performance e padrões de aprendizado',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          SizedBox(height: 3.h),
          ...suggestions
              .map((suggestion) => _buildSuggestionCard(context, suggestion)),
        ]));
  }

  Widget _buildSuggestionCard(
      BuildContext context, Map<String, dynamic> suggestion) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priority = suggestion['priority'] as String;
    final priorityColor = _getPriorityColor(priority);

    return Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: priorityColor.withValues(alpha: 0.3), width: 1),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Row(children: [
          Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: CustomIconWidget(
                      iconName: suggestion['iconName'] as String,
                      color: priorityColor,
                      size: 6.w))),
          SizedBox(width: 3.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Expanded(
                      child: Text(suggestion['title'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface))),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(priority.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: priorityColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp))),
                ]),
                SizedBox(height: 1.h),
                Text(suggestion['description'] as String,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              ])),
        ]));
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
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