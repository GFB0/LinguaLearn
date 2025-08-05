import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/confidence_slider_widget.dart';
import './widgets/flashcard_widget.dart';
import './widgets/session_header_widget.dart';
import './widgets/session_summary_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/confidence_slider_widget.dart';
import 'widgets/flashcard_widget.dart';
import 'widgets/session_header_widget.dart';
import 'widgets/session_summary_widget.dart';

class VocabularyFlashcardsScreen extends StatefulWidget {
  const VocabularyFlashcardsScreen({super.key});

  @override
  State<VocabularyFlashcardsScreen> createState() =>
      _VocabularyFlashcardsScreenState();
}

class _VocabularyFlashcardsScreenState extends State<VocabularyFlashcardsScreen>
    with TickerProviderStateMixin {
  // Session state
  int _currentCardIndex = 0;
  bool _isCardFlipped = false;
  bool _showHint = false;
  bool _isPaused = false;
  bool _showConfidenceSlider = false;
  bool _showSessionSummary = false;
  bool _autoAdvanceEnabled = true;

  // Timers
  Timer? _sessionTimer;
  Timer? _autoAdvanceTimer;
  Duration _sessionDuration = Duration.zero;

  // Statistics
  int _correctAnswers = 0;
  int _reviewAnswers = 0;
  int _skippedAnswers = 0;
  List<int> _reviewQueue = [];
  Map<int, double> _confidenceScores = {};

  // Animation controllers
  late AnimationController _swipeAnimationController;
  late AnimationController _flipAnimationController;

  // Mock vocabulary data
  final List<Map<String, dynamic>> _vocabularyCards = [
    {
      "id": 1,
      "word": "Hello",
      "phonetic": "/həˈloʊ/",
      "translation": "Olá",
      "example": "Hello, how are you today?",
      "exampleTranslation": "Olá, como você está hoje?",
      "context": "Saudação informal",
      "difficulty": "Iniciante",
      "category": "Saudações"
    },
    {
      "id": 2,
      "word": "Beautiful",
      "phonetic": "/ˈbjuːtɪfəl/",
      "translation": "Bonito(a)",
      "example": "The sunset is beautiful tonight.",
      "exampleTranslation": "O pôr do sol está bonito esta noite.",
      "context": "Descrição de aparência",
      "difficulty": "Intermediário",
      "category": "Adjetivos"
    },
    {
      "id": 3,
      "word": "Serendipity",
      "phonetic": "/ˌserənˈdɪpɪti/",
      "translation": "Serendipidade",
      "example": "Meeting you was pure serendipity.",
      "exampleTranslation": "Te conhecer foi pura serendipidade.",
      "context": "Descoberta feliz por acaso",
      "difficulty": "Avançado",
      "category": "Substantivos"
    },
    {
      "id": 4,
      "word": "Adventure",
      "phonetic": "/ədˈventʃər/",
      "translation": "Aventura",
      "example": "Life is a great adventure.",
      "exampleTranslation": "A vida é uma grande aventura.",
      "context": "Experiência emocionante",
      "difficulty": "Intermediário",
      "category": "Substantivos"
    },
    {
      "id": 5,
      "word": "Gratitude",
      "phonetic": "/ˈɡrætɪtuːd/",
      "translation": "Gratidão",
      "example": "I feel deep gratitude for your help.",
      "exampleTranslation": "Sinto profunda gratidão pela sua ajuda.",
      "context": "Sentimento de agradecimento",
      "difficulty": "Intermediário",
      "category": "Sentimentos"
    },
    {
      "id": 6,
      "word": "Magnificent",
      "phonetic": "/mæɡˈnɪfɪsənt/",
      "translation": "Magnífico(a)",
      "example": "The view from the mountain was magnificent.",
      "exampleTranslation": "A vista da montanha era magnífica.",
      "context": "Algo impressionante",
      "difficulty": "Avançado",
      "category": "Adjetivos"
    },
    {
      "id": 7,
      "word": "Journey",
      "phonetic": "/ˈdʒɜːrni/",
      "translation": "Jornada",
      "example": "Learning a language is a long journey.",
      "exampleTranslation": "Aprender um idioma é uma longa jornada.",
      "context": "Processo ou viagem",
      "difficulty": "Iniciante",
      "category": "Substantivos"
    },
    {
      "id": 8,
      "word": "Wisdom",
      "phonetic": "/ˈwɪzdəm/",
      "translation": "Sabedoria",
      "example": "Age brings wisdom and experience.",
      "exampleTranslation": "A idade traz sabedoria e experiência.",
      "context": "Conhecimento profundo",
      "difficulty": "Intermediário",
      "category": "Qualidades"
    },
    {
      "id": 9,
      "word": "Perseverance",
      "phonetic": "/ˌpɜːrsəˈvɪrəns/",
      "translation": "Perseverança",
      "example": "Success requires perseverance and hard work.",
      "exampleTranslation": "O sucesso requer perseverança e trabalho duro.",
      "context": "Persistência em objetivos",
      "difficulty": "Avançado",
      "category": "Qualidades"
    },
    {
      "id": 10,
      "word": "Harmony",
      "phonetic": "/ˈhɑːrməni/",
      "translation": "Harmonia",
      "example": "The music created perfect harmony.",
      "exampleTranslation": "A música criou harmonia perfeita.",
      "context": "Equilíbrio e paz",
      "difficulty": "Intermediário",
      "category": "Conceitos"
    },
    {
      "id": 11,
      "word": "Curiosity",
      "phonetic": "/ˌkjʊriˈɒsɪti/",
      "translation": "Curiosidade",
      "example": "Curiosity drives scientific discovery.",
      "exampleTranslation": "A curiosidade impulsiona a descoberta científica.",
      "context": "Desejo de aprender",
      "difficulty": "Intermediário",
      "category": "Sentimentos"
    },
    {
      "id": 12,
      "word": "Resilience",
      "phonetic": "/rɪˈzɪliəns/",
      "translation": "Resiliência",
      "example": "She showed great resilience during difficult times.",
      "exampleTranslation":
          "Ela mostrou grande resiliência durante tempos difíceis.",
      "context": "Capacidade de recuperação",
      "difficulty": "Avançado",
      "category": "Qualidades"
    },
    {
      "id": 13,
      "word": "Inspiration",
      "phonetic": "/ˌɪnspəˈreɪʃən/",
      "translation": "Inspiração",
      "example": "Nature is my greatest inspiration.",
      "exampleTranslation": "A natureza é minha maior inspiração.",
      "context": "Fonte de motivação",
      "difficulty": "Intermediário",
      "category": "Conceitos"
    },
    {
      "id": 14,
      "word": "Tranquility",
      "phonetic": "/træŋˈkwɪlɪti/",
      "translation": "Tranquilidade",
      "example": "The garden offers peace and tranquility.",
      "exampleTranslation": "O jardim oferece paz e tranquilidade.",
      "context": "Estado de calma",
      "difficulty": "Avançado",
      "category": "Sentimentos"
    },
    {
      "id": 15,
      "word": "Compassion",
      "phonetic": "/kəmˈpæʃən/",
      "translation": "Compaixão",
      "example": "She treated everyone with compassion.",
      "exampleTranslation": "Ela tratou todos com compaixão.",
      "context": "Empatia e cuidado",
      "difficulty": "Intermediário",
      "category": "Qualidades"
    },
    {
      "id": 16,
      "word": "Excellence",
      "phonetic": "/ˈeksələns/",
      "translation": "Excelência",
      "example": "The team strives for excellence in everything.",
      "exampleTranslation": "A equipe busca a excelência em tudo.",
      "context": "Qualidade superior",
      "difficulty": "Intermediário",
      "category": "Qualidades"
    },
    {
      "id": 17,
      "word": "Opportunity",
      "phonetic": "/ˌɑːpərˈtuːnəti/",
      "translation": "Oportunidade",
      "example": "This job is a great opportunity for growth.",
      "exampleTranslation":
          "Este trabalho é uma grande oportunidade de crescimento.",
      "context": "Chance favorável",
      "difficulty": "Iniciante",
      "category": "Conceitos"
    },
    {
      "id": 18,
      "word": "Innovation",
      "phonetic": "/ˌɪnəˈveɪʃən/",
      "translation": "Inovação",
      "example": "Technology drives innovation in education.",
      "exampleTranslation": "A tecnologia impulsiona a inovação na educação.",
      "context": "Criação de algo novo",
      "difficulty": "Avançado",
      "category": "Conceitos"
    },
    {
      "id": 19,
      "word": "Friendship",
      "phonetic": "/ˈfrendʃɪp/",
      "translation": "Amizade",
      "example": "True friendship lasts a lifetime.",
      "exampleTranslation": "A verdadeira amizade dura uma vida inteira.",
      "context": "Relacionamento próximo",
      "difficulty": "Iniciante",
      "category": "Relacionamentos"
    },
    {
      "id": 20,
      "word": "Determination",
      "phonetic": "/dɪˌtɜːrmɪˈneɪʃən/",
      "translation": "Determinação",
      "example": "Her determination helped her achieve her goals.",
      "exampleTranslation":
          "Sua determinação a ajudou a alcançar seus objetivos.",
      "context": "Firmeza de propósito",
      "difficulty": "Avançado",
      "category": "Qualidades"
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _swipeAnimationController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _sessionDuration = Duration(seconds: _sessionDuration.inSeconds + 1);
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    HapticFeedback.selectionClick();
  }

  void _flipCard() {
    setState(() {
      _isCardFlipped = !_isCardFlipped;
    });
    HapticFeedback.selectionClick();
  }

  void _showHintForCard() {
    setState(() {
      _showHint = true;
    });
    HapticFeedback.lightImpact();

    // Hide hint after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showHint = false;
        });
      }
    });
  }

  void _handleKnowIt() {
    _correctAnswers++;
    _showConfidenceSliderAndAdvance();
    HapticFeedback.lightImpact();
  }

  void _handleReviewAgain() {
    _reviewAnswers++;
    _reviewQueue.add(_currentCardIndex);
    _showConfidenceSliderAndAdvance();
    HapticFeedback.lightImpact();
  }

  void _handleSkip() {
    _skippedAnswers++;
    _advanceToNextCard();
    HapticFeedback.selectionClick();
  }

  void _showConfidenceSliderAndAdvance() {
    setState(() {
      _showConfidenceSlider = true;
    });
  }

  void _handleConfidenceSubmit(double confidence) {
    _confidenceScores[_currentCardIndex] = confidence;
    setState(() {
      _showConfidenceSlider = false;
    });

    if (_autoAdvanceEnabled) {
      _autoAdvanceTimer = Timer(const Duration(seconds: 2), () {
        _advanceToNextCard();
      });
    } else {
      _advanceToNextCard();
    }
  }

  void _advanceToNextCard() {
    _autoAdvanceTimer?.cancel();

    if (_currentCardIndex >= _vocabularyCards.length - 1) {
      _showSessionSummaryDialog();
      return;
    }

    setState(() {
      _currentCardIndex++;
      _isCardFlipped = false;
      _showHint = false;
      _showConfidenceSlider = false;
    });
  }

  void _showSessionSummaryDialog() {
    final accuracy =
        _correctAnswers / (_correctAnswers + _reviewAnswers + _skippedAnswers);
    final summaryData = {
      "accuracy": accuracy,
      "newWords": _correctAnswers,
      "reviewWords": _reviewQueue.length,
      "totalTime": _sessionDuration,
      "skippedWords": _skippedAnswers,
    };

    setState(() {
      _showSessionSummary = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SessionSummaryWidget(
        summaryData: summaryData,
        onContinue: () {
          Navigator.pop(context);
          _restartSession();
        },
        onRestart: () {
          Navigator.pop(context);
          _restartSession();
        },
        onHome: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard-screen',
            (route) => false,
          );
        },
      ),
    );
  }

  void _restartSession() {
    setState(() {
      _currentCardIndex = 0;
      _isCardFlipped = false;
      _showHint = false;
      _isPaused = false;
      _showConfidenceSlider = false;
      _showSessionSummary = false;
      _correctAnswers = 0;
      _reviewAnswers = 0;
      _skippedAnswers = 0;
      _reviewQueue.clear();
      _confidenceScores.clear();
      _sessionDuration = Duration.zero;
    });
  }

  double get _sessionProgress {
    return (_currentCardIndex + 1) / _vocabularyCards.length;
  }

  String get _currentDifficulty {
    return _vocabularyCards[_currentCardIndex]["difficulty"] as String;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Flashcards de Vocabulário',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _autoAdvanceEnabled ? 'play_circle' : 'pause_circle',
              color: _autoAdvanceEnabled
                  ? AppTheme.successLight
                  : AppTheme.warningLight,
              size: 6.w,
            ),
            onPressed: () {
              setState(() {
                _autoAdvanceEnabled = !_autoAdvanceEnabled;
              });
              HapticFeedback.selectionClick();
            },
            tooltip: _autoAdvanceEnabled
                ? 'Desativar avanço automático'
                : 'Ativar avanço automático',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Session header
          SessionHeaderWidget(
            currentCard: _currentCardIndex + 1,
            totalCards: _vocabularyCards.length,
            difficultyLevel: _currentDifficulty,
            sessionTime: _sessionDuration,
            isPaused: _isPaused,
            onPausePressed: _togglePause,
            progress: _sessionProgress,
          ),

          // Main flashcard area
          Expanded(
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.surface,
                        colorScheme.surface.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),

                // Flashcard
                Center(
                  child: FlashcardWidget(
                    cardData: _vocabularyCards[_currentCardIndex],
                    onSwipeRight: _handleKnowIt,
                    onSwipeLeft: _handleReviewAgain,
                    onFlip: _flipCard,
                    isFlipped: _isCardFlipped,
                    showHint: _showHint,
                  ),
                ),

                // Confidence slider overlay
                if (_showConfidenceSlider)
                  Positioned(
                    bottom: 20.h,
                    left: 0,
                    right: 0,
                    child: ConfidenceSliderWidget(
                      isVisible: _showConfidenceSlider,
                      onSubmit: () => _handleConfidenceSubmit(0.5),
                      onChanged: (value) {
                        // Handle confidence change
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Action buttons
          ActionButtonsWidget(
            onKnowIt: _handleKnowIt,
            onReviewAgain: _handleReviewAgain,
            onSkip: _handleSkip,
            onHint: _showHintForCard,
            showHint: !_showHint,
            isEnabled: !_showConfidenceSlider,
          ),
        ],
      ),
    );
  }
}