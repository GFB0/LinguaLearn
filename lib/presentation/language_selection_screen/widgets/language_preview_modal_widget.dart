import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LanguagePreviewModalWidget extends StatelessWidget {
  final Map<String, dynamic> language;
  final VoidCallback onClose;
  final VoidCallback onSelectLanguage;

  const LanguagePreviewModalWidget({
    super.key,
    required this.language,
    required this.onClose,
    required this.onSelectLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: 70.h,
        maxWidth: 90.w,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Flag and language name
                Container(
                  width: 12.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(language["flagUrl"] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language["namePortuguese"] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        language["nameNative"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sample lesson preview
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'play_circle_outline',
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Amostra da Lição',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          language["sampleLesson"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 14.sp,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Audio sample button
                        GestureDetector(
                          onTap: () {
                            // Play native speaker audio sample
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reproduzindo áudio nativo...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'volume_up',
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Ouvir pronúncia nativa',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Course statistics
                  Text(
                    'Estatísticas do Curso',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Lições',
                          '${language["lessonsCount"]}',
                          Icons.book_outlined,
                          colorScheme,
                          theme,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Tempo Est.',
                          language["estimatedTime"] as String,
                          Icons.schedule,
                          colorScheme,
                          theme,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Dificuldade',
                          language["difficulty"] as String,
                          Icons.trending_up,
                          colorScheme,
                          theme,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Popularidade',
                          language["popularity"] as String,
                          Icons.people_outline,
                          colorScheme,
                          theme,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Why learn this language section
                  Text(
                    'Por que aprender ${language["namePortuguese"]}?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    language["whyLearn"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose,
                    child: Text('Fechar'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSelectLanguage,
                    child: Text('Selecionar Idioma'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            size: 20,
            color: colorScheme.primary,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
