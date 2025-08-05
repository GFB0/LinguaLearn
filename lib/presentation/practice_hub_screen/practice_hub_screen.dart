import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/practice_card_widget.dart';
import './widgets/quick_practice_modal.dart';
import './widgets/recent_practice_widget.dart';
import './widgets/smart_review_widget.dart';
import './widgets/statistics_bottom_sheet.dart';
import './widgets/streak_header_widget.dart';
import './widgets/weekly_challenge_widget.dart';

class PracticeHubScreen extends StatefulWidget {
  const PracticeHubScreen({super.key});

  @override
  State<PracticeHubScreen> createState() => _PracticeHubScreenState();
}

class _PracticeHubScreenState extends State<PracticeHubScreen> {
  final PageController _pageController = PageController();
  bool _isRefreshing = false;

  // Mock data for practice types
  final List<Map<String, dynamic>> practiceTypes = [
    {
      'title': 'Revisão de Vocabulário',
      'description': 'Flashcards interativos para memorização',
      'iconName': 'quiz',
      'duration': '15-20 min',
      'difficulty': 'Intermediário',
      'lastCompleted': '2 horas atrás',
      'accuracy': 87.5,
      'totalSessions': 45,
      'improvementTrend': '+5%',
      'route': '/vocabulary-flashcards-screen',
    },
    {
      'title': 'Prática de Pronúncia',
      'description': 'Exercícios de fala com feedback de IA',
      'iconName': 'mic',
      'duration': '10-15 min',
      'difficulty': 'Avançado',
      'lastCompleted': '1 dia atrás',
      'accuracy': 72.3,
      'totalSessions': 28,
      'improvementTrend': '+12%',
      'route': '/practice-hub-screen',
    },
    {
      'title': 'Exercícios de Gramática',
      'description': 'Quebra-cabeças de estrutura linguística',
      'iconName': 'auto_fix_high',
      'duration': '20-25 min',
      'difficulty': 'Intermediário',
      'lastCompleted': '3 horas atrás',
      'accuracy': 91.2,
      'totalSessions': 52,
      'improvementTrend': '+3%',
      'route': '/practice-hub-screen',
    },
    {
      'title': 'Compreensão Auditiva',
      'description': 'Áudios nativos com exercícios',
      'iconName': 'headphones',
      'duration': '25-30 min',
      'difficulty': 'Avançado',
      'lastCompleted': '5 horas atrás',
      'accuracy': 68.9,
      'totalSessions': 31,
      'improvementTrend': '+8%',
      'route': '/practice-hub-screen',
    },
  ];

  // Mock data for smart review
  final List<Map<String, dynamic>> reviewWords = [
    {
      'word': 'Serendipity',
      'translation': 'Serendipidade',
      'urgency': 'alta',
      'nextReview': '2h',
    },
    {
      'word': 'Ephemeral',
      'translation': 'Efêmero',
      'urgency': 'média',
      'nextReview': '6h',
    },
    {
      'word': 'Ubiquitous',
      'translation': 'Onipresente',
      'urgency': 'baixa',
      'nextReview': '1d',
    },
    {
      'word': 'Mellifluous',
      'translation': 'Melodioso',
      'urgency': 'alta',
      'nextReview': '1h',
    },
  ];

  // Mock data for recent practices
  final List<Map<String, dynamic>> recentPractices = [
    {
      'title': 'Vocabulário',
      'iconName': 'quiz',
      'date': 'Hoje, 14:30',
      'score': 87.5,
      'badge': 'Excelente',
    },
    {
      'title': 'Gramática',
      'iconName': 'auto_fix_high',
      'date': 'Ontem, 19:15',
      'score': 91.2,
      'badge': 'Perfeito',
    },
    {
      'title': 'Pronúncia',
      'iconName': 'mic',
      'date': '2 dias atrás',
      'score': 72.3,
      'badge': 'Bom',
    },
    {
      'title': 'Escuta',
      'iconName': 'headphones',
      'date': '3 dias atrás',
      'score': 68.9,
      'badge': 'Bom',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
            title: Text('Hub de Prática',
                style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: _showStatistics,
                  icon: CustomIconWidget(
                      iconName: 'analytics',
                      color: colorScheme.onSurface,
                      size: 6.w),
                  tooltip: 'Estatísticas'),
              SizedBox(width: 2.w),
            ]),
        body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Streak Header
                      StreakHeaderWidget(
                          streakDays: 7,
                          motivationalMessage:
                              'Incrível! Você está mantendo uma sequência consistente. Continue assim!'),

                      // Practice Types Cards
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Text('Tipos de Prática',
                              style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface))),

                      SizedBox(
                          height: 25.h,
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: practiceTypes.length,
                              itemBuilder: (context, index) {
                                final practice = practiceTypes[index];
                                return PracticeCardWidget(
                                    title: practice['title'] as String,
                                    description:
                                        practice['description'] as String,
                                    iconName: practice['iconName'] as String,
                                    duration: practice['duration'] as String,
                                    difficulty:
                                        practice['difficulty'] as String,
                                    lastCompleted:
                                        practice['lastCompleted'] as String,
                                    accuracy: practice['accuracy'] as double,
                                    totalSessions:
                                        practice['totalSessions'] as int,
                                    improvementTrend:
                                        practice['improvementTrend'] as String,
                                    onTap: () => _navigateToPractice(
                                        practice['route'] as String),
                                    onLongPress: () =>
                                        _showCustomizationOptions(practice));
                              })),

                      // Page indicator
                      SizedBox(height: 1.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              practiceTypes.length,
                              (index) => Container(
                                  width: 2.w,
                                  height: 2.w,
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                      color: colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      shape: BoxShape.circle)))),

                      // Smart Review Section
                      SmartReviewWidget(
                          reviewWords: reviewWords,
                          onViewAll: () => Navigator.pushNamed(
                              context, '/vocabulary-flashcards-screen')),

                      // Weekly Challenge
                      WeeklyChallengeWidget(
                          challengeTitle: 'Mestre das Palavras',
                          challengeDescription:
                              'Aprenda 50 novas palavras esta semana e ganhe pontos extras!',
                          currentProgress: 32,
                          targetProgress: 50,
                          userRank: 15,
                          totalParticipants: 1247,
                          onViewLeaderboard: _showLeaderboard,
                          onJoinChallenge: _joinChallenge),

                      // Recent Practice
                      RecentPracticeWidget(recentPractices: recentPractices),

                      // Bottom spacing for FAB
                      SizedBox(height: 10.h),
                    ]))),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _showQuickPractice,
            foregroundColor: Colors.white,
            icon: CustomIconWidget(
                iconName: 'flash_on', color: Colors.white, size: 5.w),
            label: Text('Prática Rápida',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600))),
        bottomNavigationBar: CustomBottomBar.dashboard(
            currentIndex: 2, // Practice tab
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/dashboard-screen', (route) => false);
                  break;
                case 1:
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/lesson-detail-screen', (route) => false);
                  break;
                case 2:
                  // Already on practice hub
                  break;
                case 3:
                  Navigator.pushNamedAndRemoveUntil(context,
                      '/vocabulary-flashcards-screen', (route) => false);
                  break;
              }
            }));
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call to refresh data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Recomendações atualizadas!'),
          duration: Duration(seconds: 2)));
    }
  }

  void _navigateToPractice(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showCustomizationOptions(Map<String, dynamic> practice) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Personalizar ${practice['title']}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 2.h),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'tune',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w),
                  title: const Text('Ajustar Dificuldade'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDifficultyAdjustment();
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w),
                  title: const Text('Duração da Sessão'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDurationSettings();
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w),
                  title: const Text('Preferências de Conteúdo'),
                  onTap: () {
                    Navigator.pop(context);
                    _showContentPreferences();
                  }),
              SizedBox(height: 2.h),
            ])));
  }

  void _showQuickPractice() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const QuickPracticeModal());
  }

  void _showStatistics() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const StatisticsBottomSheet());
  }

  void _showLeaderboard() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Ranking em breve! Continue praticando para subir na classificação.'),
        duration: Duration(seconds: 3)));
  }

  void _joinChallenge() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Desafio aceito! Boa sorte na sua jornada de aprendizado.'),
        duration: Duration(seconds: 3)));
  }

  void _showDifficultyAdjustment() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ajuste de dificuldade em desenvolvimento.'),
        duration: Duration(seconds: 2)));
  }

  void _showDurationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Configurações de duração em desenvolvimento.'),
        duration: Duration(seconds: 2)));
  }

  void _showContentPreferences() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Preferências de conteúdo em desenvolvimento.'),
        duration: Duration(seconds: 2)));
  }
}
