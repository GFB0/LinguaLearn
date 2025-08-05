import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class ProficiencySelectorWidget extends StatelessWidget {
  final String selectedLevel;
  final ValueChanged<String> onLevelChanged;

  const ProficiencySelectorWidget({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, String>> proficiencyLevels = [
      {
        'level': 'Iniciante',
        'description': 'Começando do zero, aprendendo o básico',
      },
      {
        'level': 'Intermediário',
        'description': 'Já conheço algumas palavras e frases',
      },
      {
        'level': 'Avançado',
        'description': 'Posso ter conversas básicas',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qual é o seu nível atual?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 3.h),

          // Proficiency level options
          ...proficiencyLevels.map((level) {
            final isSelected = selectedLevel == level['level'];
            return GestureDetector(
              onTap: () => onLevelChanged(level['level']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Radio button indicator
                    Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: 2,
                        ),
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 3.w),

                    // Level information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level['level']!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            level['description']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
