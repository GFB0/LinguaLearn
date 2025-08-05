import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickPracticeModal extends StatefulWidget {
  const QuickPracticeModal({super.key});

  @override
  State<QuickPracticeModal> createState() => _QuickPracticeModalState();
}

class _QuickPracticeModalState extends State<QuickPracticeModal> {
  String selectedType = 'vocabulary';
  int selectedDuration = 5;

  final List<Map<String, dynamic>> practiceTypes = [
    {
      'id': 'vocabulary',
      'title': 'Vocabulário',
      'description': 'Revisão rápida de palavras',
      'iconName': 'quiz',
    },
    {
      'id': 'pronunciation',
      'title': 'Pronúncia',
      'description': 'Prática de fala',
      'iconName': 'mic',
    },
    {
      'id': 'grammar',
      'title': 'Gramática',
      'description': 'Exercícios de estrutura',
      'iconName': 'auto_fix_high',
    },
    {
      'id': 'listening',
      'title': 'Escuta',
      'description': 'Compreensão auditiva',
      'iconName': 'headphones',
    },
  ];

  final List<int> durations = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 10.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2)))),
              SizedBox(height: 3.h),
              Row(children: [
                CustomIconWidget(iconName: 'flash_on', size: 6.w),
                SizedBox(width: 2.w),
                Text('Prática Rápida',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface)),
              ]),
              SizedBox(height: 1.h),
              Text('Escolha o tipo de prática e duração para uma sessão focada',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              SizedBox(height: 3.h),
              Text('Tipo de Prática',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface)),
              SizedBox(height: 2.h),
              ...practiceTypes
                  .map((type) => _buildPracticeTypeOption(context, type)),
              SizedBox(height: 3.h),
              Text('Duração (minutos)',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface)),
              SizedBox(height: 2.h),
              Row(
                  children: durations
                      .map((duration) => _buildDurationChip(context, duration))
                      .toList()),
              SizedBox(height: 4.h),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startQuickPractice();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text('Começar Prática ($selectedDuration min)',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600)))),
              SizedBox(height: 2.h),
            ]));
  }

  Widget _buildPracticeTypeOption(
      BuildContext context, Map<String, dynamic> type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedType == type['id'];

    return GestureDetector(
        onTap: () {
          setState(() {
            selectedType = type['id'] as String;
          });
        },
        child: Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : Colors.transparent,
                    width: 2)),
            child: Row(children: [
              Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: CustomIconWidget(
                          iconName: type['iconName'] as String,
                          color: isSelected
                              ? Colors.white
                              : colorScheme.onSurfaceVariant,
                          size: 5.w))),
              SizedBox(width: 3.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(type['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : colorScheme.onSurface)),
                    SizedBox(height: 0.5.h),
                    Text(type['description'] as String,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ])),
              if (isSelected)
                CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w),
            ])));
  }

  Widget _buildDurationChip(BuildContext context, int duration) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedDuration == duration;

    return Expanded(
        child: GestureDetector(
            onTap: () {
              setState(() {
                selectedDuration = duration;
              });
            },
            child: Container(
                margin: EdgeInsets.only(
                    right: duration != durations.last ? 2.w : 0),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: 1)),
                child: Center(
                    child: Text('${duration}min',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : colorScheme.onSurface))))));
  }

  void _startQuickPractice() {
    // Navigate to appropriate practice screen based on selected type
    String route;
    switch (selectedType) {
      case 'vocabulary':
        route = '/vocabulary-flashcards-screen';
        break;
      case 'pronunciation':
        route =
            '/practice-hub-screen'; // Would navigate to pronunciation practice
        break;
      case 'grammar':
        route = '/practice-hub-screen'; // Would navigate to grammar practice
        break;
      case 'listening':
        route = '/practice-hub-screen'; // Would navigate to listening practice
        break;
      default:
        route = '/vocabulary-flashcards-screen';
    }

    Navigator.pushNamed(context, route);
  }
}
