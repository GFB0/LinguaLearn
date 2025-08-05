import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/language_card_widget.dart';
import './widgets/language_preview_modal_widget.dart';
import './widgets/proficiency_selector_widget.dart';
import './widgets/progress_indicator_widget.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguageId;
  String selectedProficiencyLevel = 'Iniciante';
  String searchQuery = '';
  bool isRefreshing = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data for available languages
  final List<Map<String, dynamic>> availableLanguages = [
    {
      "id": "en",
      "namePortuguese": "Inglês",
      "nameNative": "English",
      "flagUrl":
          "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=100&h=60&fit=crop",
      "difficulty": "Iniciante",
      "lessonsCount": 120,
      "estimatedTime": "3-6 meses",
      "popularity": "Muito Popular",
      "sampleLesson": "Hello! My name is John. Nice to meet you!",
      "whyLearn":
          "O inglês é a língua mais falada no mundo dos negócios e tecnologia. Essencial para oportunidades de carreira global e acesso a conteúdo internacional.",
    },
    {
      "id": "es",
      "namePortuguese": "Espanhol",
      "nameNative": "Español",
      "flagUrl":
          "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=100&h=60&fit=crop",
      "difficulty": "Iniciante",
      "lessonsCount": 95,
      "estimatedTime": "2-4 meses",
      "popularity": "Popular",
      "sampleLesson": "¡Hola! Me llamo María. ¿Cómo estás?",
      "whyLearn":
          "Falado por mais de 500 milhões de pessoas, o espanhol abre portas na América Latina e Espanha. Ideal para negócios e viagens.",
    },
    {
      "id": "fr",
      "namePortuguese": "Francês",
      "nameNative": "Français",
      "flagUrl":
          "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=100&h=60&fit=crop",
      "difficulty": "Intermediário",
      "lessonsCount": 110,
      "estimatedTime": "4-8 meses",
      "popularity": "Popular",
      "sampleLesson": "Bonjour! Je m'appelle Pierre. Comment allez-vous?",
      "whyLearn":
          "Língua da diplomacia e cultura. Essencial para carreiras internacionais e acesso à rica cultura francófona.",
    },
    {
      "id": "de",
      "namePortuguese": "Alemão",
      "nameNative": "Deutsch",
      "flagUrl":
          "https://images.unsplash.com/photo-1467269204594-9661b134dd2b?w=100&h=60&fit=crop",
      "difficulty": "Avançado",
      "lessonsCount": 140,
      "estimatedTime": "6-12 meses",
      "popularity": "Moderada",
      "sampleLesson": "Guten Tag! Ich heiße Hans. Wie geht es Ihnen?",
      "whyLearn":
          "Alemanha é a maior economia da Europa. Ideal para oportunidades de trabalho e estudos na Europa Central.",
    },
    {
      "id": "it",
      "namePortuguese": "Italiano",
      "nameNative": "Italiano",
      "flagUrl":
          "https://images.unsplash.com/photo-1515542622106-78bda8ba0e5b?w=100&h=60&fit=crop",
      "difficulty": "Intermediário",
      "lessonsCount": 85,
      "estimatedTime": "3-6 meses",
      "popularity": "Moderada",
      "sampleLesson": "Ciao! Mi chiamo Marco. Come stai?",
      "whyLearn":
          "Língua da arte, culinária e moda. Perfeita para apreciadores de cultura e gastronomia italiana.",
    },
    {
      "id": "ja",
      "namePortuguese": "Japonês",
      "nameNative": "日本語",
      "flagUrl":
          "https://images.unsplash.com/photo-1480796927426-f609979314bd?w=100&h=60&fit=crop",
      "difficulty": "Avançado",
      "lessonsCount": 180,
      "estimatedTime": "8-15 meses",
      "popularity": "Crescente",
      "sampleLesson": "こんにちは！私の名前は田中です。",
      "whyLearn":
          "Portal para a tecnologia japonesa e cultura pop. Essencial para carreiras em tecnologia e entretenimento.",
    },
    {
      "id": "ko",
      "namePortuguese": "Coreano",
      "nameNative": "한국어",
      "flagUrl":
          "https://images.unsplash.com/photo-1517154421773-0529f29ea451?w=100&h=60&fit=crop",
      "difficulty": "Avançado",
      "lessonsCount": 160,
      "estimatedTime": "7-12 meses",
      "popularity": "Crescente",
      "sampleLesson": "안녕하세요! 제 이름은 김민수입니다.",
      "whyLearn":
          "Coreia do Sul é líder em tecnologia e entretenimento. Ideal para fãs de K-pop e tecnologia.",
    },
    {
      "id": "zh",
      "namePortuguese": "Chinês (Mandarim)",
      "nameNative": "中文",
      "flagUrl":
          "https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=100&h=60&fit=crop",
      "difficulty": "Avançado",
      "lessonsCount": 200,
      "estimatedTime": "10-18 meses",
      "popularity": "Alta",
      "sampleLesson": "你好！我叫王小明。",
      "whyLearn":
          "Língua mais falada do mundo. Essencial para negócios com a China e oportunidades na Ásia.",
    },
  ];

  List<Map<String, dynamic>> get filteredLanguages {
    if (searchQuery.isEmpty) return availableLanguages;
    return availableLanguages.where((language) {
      final namePortuguese =
          (language["namePortuguese"] as String).toLowerCase();
      final nameNative = (language["nameNative"] as String).toLowerCase();
      final query = searchQuery.toLowerCase();
      return namePortuguese.contains(query) || nameNative.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate API call to refresh language data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Idiomas atualizados com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _selectLanguage(String languageId) {
    setState(() {
      selectedLanguageId = languageId;
    });

    // Haptic feedback for selection
    HapticFeedback.lightImpact();
  }

  void _showLanguagePreview(Map<String, dynamic> language) {
    // Haptic feedback for long press
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: LanguagePreviewModalWidget(
          language: language,
          onClose: () => Navigator.of(context).pop(),
          onSelectLanguage: () {
            Navigator.of(context).pop();
            _selectLanguage(language["id"] as String);
          },
        ),
      ),
    );
  }

  void _continueToNextStep() {
    if (selectedLanguageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um idioma para continuar.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to dashboard screen (goal setting would be next in real app)
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard-screen',
      (route) => false,
    );
  }

  void _skipSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pular Seleção'),
        content: const Text(
            'Você pode escolher seu idioma mais tarde nas configurações. Deseja continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard-screen',
                (route) => false,
              );
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            const ProgressIndicatorWidget(
              currentStep: 1,
              totalSteps: 3,
            ),

            // Header with welcome message and skip option
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escolha seu idioma',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Qual idioma você gostaria de aprender?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _skipSelection,
                    child: Text(
                      'Pular',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar idiomas...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                ),
              ),
            ),

            // Main content with language grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Language grid
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 2.w,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final language = filteredLanguages[index];
                            final isSelected =
                                selectedLanguageId == language["id"];

                            return GestureDetector(
                              onLongPress: () => _showLanguagePreview(language),
                              child: LanguageCardWidget(
                                language: language,
                                isSelected: isSelected,
                                onTap: () =>
                                    _selectLanguage(language["id"] as String),
                              ),
                            );
                          },
                          childCount: filteredLanguages.length,
                        ),
                      ),
                    ),

                    // Proficiency level selector
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: ProficiencySelectorWidget(
                          selectedLevel: selectedProficiencyLevel,
                          onLevelChanged: (level) {
                            setState(() {
                              selectedProficiencyLevel = level;
                            });
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ),
                    ),

                    // Why this language helper text
                    if (selectedLanguageId != null)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
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
                                    iconName: 'lightbulb_outline',
                                    size: 20,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Por que este idioma?',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Criaremos um caminho de aprendizado personalizado baseado no seu nível atual e objetivos. Você poderá ajustar a dificuldade a qualquer momento.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 12.sp,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Bottom spacing for continue button
                    SliverToBoxAdapter(
                      child: SizedBox(height: 10.h),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Continue button in bottom safe area
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              onPressed:
                  selectedLanguageId != null ? _continueToNextStep : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 6.h),
                backgroundColor: selectedLanguageId != null
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                foregroundColor: selectedLanguageId != null
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              child: Text(
                selectedLanguageId != null
                    ? 'Continuar'
                    : 'Selecione um idioma',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
