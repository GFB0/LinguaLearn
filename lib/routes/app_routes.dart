import 'package:flutter/material.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/practice_hub_screen/practice_hub_screen.dart';
import '../presentation/lesson_detail_screen/lesson_detail_screen.dart';
import '../presentation/vocabulary_flashcards_screen/vocabulary_flashcards_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/language_selection_screen/language_selection_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String dashboard = '/dashboard-screen';
  static const String practiceHub = '/practice-hub-screen';
  static const String lessonDetail = '/lesson-detail-screen';
  static const String vocabularyFlashcards = '/vocabulary-flashcards-screen';
  static const String registration = '/registration-screen';
  static const String languageSelection = '/language-selection-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardScreen(),
    dashboard: (context) => const DashboardScreen(),
    practiceHub: (context) => const PracticeHubScreen(),
    lessonDetail: (context) => const LessonDetailScreen(),
    vocabularyFlashcards: (context) => const VocabularyFlashcardsScreen(),
    registration: (context) => const RegistrationScreen(),
    languageSelection: (context) => const LanguageSelectionScreen(),
    // TODO: Add your other routes here
  };
}
