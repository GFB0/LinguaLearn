import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/continue_learning_card_widget.dart';
import './widgets/daily_challenges_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/progress_ring_widget.dart';
import './widgets/quick_stats_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock user data
  final Map<String, dynamic> userData = {
    "userName": "Maria Silva",
    "currentStreak": 7,
    "weeklyProgress": 0.68,
    "motivationalMessage":
        "Você está indo muito bem! Continue assim para manter sua sequência.",
  };

  // Mock current lesson data
  final Map<String, dynamic> currentLesson = {
    "title": "Conversação Básica: Apresentações",
    "thumbnail":
        "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "estimatedTime": 15,
    "progress": 0.35,
  };

  // Mock daily challenges data
  final List<Map<String, dynamic>> dailyChallenges = [
    {
      "type": "vocabulary",
      "title": "Revisão de Vocabulário",
      "description": "Revise 20 palavras aprendidas esta semana",
      "progress": 0.75,
      "xpReward": 50,
    },
    {
      "type": "pronunciation",
      "title": "Prática de Pronúncia",
      "description": "Pratique a pronúncia de 10 frases",
      "progress": 0.40,
      "xpReward": 75,
    },
    {
      "type": "grammar",
      "title": "Quiz de Gramática",
      "description": "Complete o quiz sobre verbos regulares",
      "progress": 1.0,
      "xpReward": 100,
    },
  ];

  // Mock achievements data
  final List<Map<String, dynamic>> achievements = [
    {
      "title": "Sequência de 7 Dias",
      "description": "Você estudou por 7 dias consecutivos!",
      "category": "streak",
      "isUnlocked": true,
      "dateUnlocked": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "title": "Primeira Lição",
      "description": "Parabéns por completar sua primeira lição!",
      "category": "lesson",
      "isUnlocked": true,
      "dateUnlocked": DateTime.now().subtract(const Duration(days: 6)),
    },
    {
      "title": "Vocabulário Básico",
      "description": "Você aprendeu 50 palavras novas!",
      "category": "vocabulary",
      "isUnlocked": true,
      "dateUnlocked": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "title": "Mestre da Pronúncia",
      "description": "Complete 100 exercícios de pronúncia",
      "category": "pronunciation",
      "isUnlocked": false,
      "dateUnlocked": null,
    },
  ];

  // Mock quick stats data
  final Map<String, dynamic> quickStats = {
    "lessonsCompleted": 12,
    "wordsLearned": 156,
    "speakingTimeMinutes": 45,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar.dashboard(
        title: 'LinguaLearn',
        onMenuPressed: () => _showMenuBottomSheet(context),
        onProfilePressed: () => _showProfileBottomSheet(context),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                GreetingHeaderWidget(
                  userName: userData["userName"] as String,
                  onNotificationTap: () => _showNotifications(context),
                ),

                // Progress Ring
                ProgressRingWidget(
                  progress: userData["weeklyProgress"] as double,
                  currentStreak: userData["currentStreak"] as int,
                  motivationalMessage:
                      userData["motivationalMessage"] as String,
                ),

                SizedBox(height: 2.h),

                // Continue Learning Card
                ContinueLearningCardWidget(
                  currentLesson: currentLesson,
                  onPlayPressed: () => _startLesson(context),
                ),

                SizedBox(height: 2.h),

                // Daily Challenges
                DailyChallengesWidget(
                  challenges: dailyChallenges,
                  onChallengePressed: (index) =>
                      _startChallenge(context, index),
                ),

                SizedBox(height: 2.h),

                // Achievement Badges
                AchievementBadgesWidget(
                  achievements: achievements,
                  onBadgePressed: (index) =>
                      _showAchievementDetails(context, index),
                ),

                SizedBox(height: 2.h),

                // Quick Stats
                QuickStatsWidget(stats: quickStats),

                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.dashboard(
        currentIndex: 0,
        onTap: (index) => _onBottomNavTap(context, index),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startNextLesson(context),
        icon: CustomIconWidget(
          iconName: 'play_arrow',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Iniciar Lição',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados atualizados!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Selecionar Idioma'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/language-selection-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações em breve!')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Ajuda'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Central de ajuda em breve!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Meu Perfil'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil em breve!')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Estatísticas'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Estatísticas em breve!')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'logout',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/registration-screen',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Você não tem notificações no momento.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startLesson(BuildContext context) {
    Navigator.pushNamed(context, '/lesson-detail-screen');
  }

  void _startNextLesson(BuildContext context) {
    Navigator.pushNamed(context, '/lesson-detail-screen');
  }

  void _startChallenge(BuildContext context, int index) {
    final challenge = dailyChallenges[index];
    final challengeType = challenge["type"] as String;

    switch (challengeType) {
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

  void _showAchievementDetails(BuildContext context, int index) {
    final achievement = achievements[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement["title"] as String),
        content: Text(achievement["description"] as String),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(BuildContext context, int index) {
    final routes = [
      '/dashboard-screen',
      '/lesson-detail-screen',
      '/practice-hub-screen',
      '/vocabulary-flashcards-screen',
    ];

    if (index < routes.length && index != 0) {
      Navigator.pushNamed(context, routes[index]);
    }
  }
}
