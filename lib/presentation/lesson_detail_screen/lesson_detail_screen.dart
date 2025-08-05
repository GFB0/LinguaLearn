import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/comments_section_widget.dart';
import './widgets/expandable_section_widget.dart';
import './widgets/lesson_header_widget.dart';
import './widgets/lesson_video_widget.dart';
import './widgets/prerequisite_card_widget.dart';
import './widgets/user_progress_widget.dart';
import './widgets/vocabulary_item_widget.dart';
import 'widgets/comments_section_widget.dart';
import 'widgets/expandable_section_widget.dart';
import 'widgets/lesson_header_widget.dart';
import 'widgets/lesson_video_widget.dart';
import 'widgets/prerequisite_card_widget.dart';
import 'widgets/user_progress_widget.dart';
import 'widgets/vocabulary_item_widget.dart';

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isBookmarked = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  // Mock data for lesson details
  final Map<String, dynamic> lessonData = {
    "id": 1,
    "title": "Conversação Básica em Inglês",
    "difficulty": "Intermediário",
    "duration": "25 min",
    "completionPercentage": 0.65,
    "videoThumbnail":
        "https://images.pexels.com/photos/5212345/pexels-photo-5212345.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "videoTitle": "Introdução à Conversação Básica",
    "videoDuration": "8:45",
    "objectives": [
      "Aprender cumprimentos básicos em inglês",
      "Praticar apresentações pessoais",
      "Dominar perguntas e respostas simples",
      "Desenvolver confiança na conversação"
    ],
    "vocabulary": [
      {
        "word": "Hello",
        "translation": "Olá",
        "pronunciation": "/həˈloʊ/",
        "example": "Hello, how are you today?"
      },
      {
        "word": "Nice to meet you",
        "translation": "Prazer em conhecê-lo",
        "pronunciation": "/naɪs tu mit ju/",
        "example": "Nice to meet you, I'm Sarah."
      },
      {
        "word": "Where are you from?",
        "translation": "De onde você é?",
        "pronunciation": "/wɛr ɑr ju frʌm/",
        "example": "Where are you from? I'm from Brazil."
      },
      {
        "word": "Thank you",
        "translation": "Obrigado",
        "pronunciation": "/θæŋk ju/",
        "example": "Thank you for your help."
      }
    ],
    "grammarPoints": [
      "Uso do verbo 'to be' em apresentações",
      "Formação de perguntas com 'Wh-questions'",
      "Pronomes pessoais (I, you, he, she)",
      "Artigos definidos e indefinidos (a, an, the)"
    ]
  };

  final List<Map<String, dynamic>> prerequisiteLessons = [
    {
      "id": 1,
      "title": "Alfabeto e Pronúncia Básica",
      "difficulty": "Iniciante",
      "isCompleted": true,
      "completionPercentage": 1.0,
    },
    {
      "id": 2,
      "title": "Números e Cores",
      "difficulty": "Iniciante",
      "isCompleted": true,
      "completionPercentage": 0.85,
    },
    {
      "id": 3,
      "title": "Verbos Essenciais",
      "difficulty": "Intermediário",
      "isCompleted": false,
      "completionPercentage": 0.3,
    }
  ];

  final List<Map<String, dynamic>> userAttempts = [
    {
      "score": 0.85,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "timeSpent": 22,
    },
    {
      "score": 0.72,
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "timeSpent": 28,
    },
    {
      "score": 0.68,
      "date": DateTime.now().subtract(const Duration(days: 8)),
      "timeSpent": 25,
    },
    {
      "score": 0.91,
      "date": DateTime.now().subtract(const Duration(days: 12)),
      "timeSpent": 20,
    }
  ];

  final List<Map<String, dynamic>> comments = [
    {
      "id": 1,
      "userName": "Maria Silva",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "Excelente lição! As explicações estão muito claras e os exemplos são práticos. Consegui entender melhor como usar as expressões no dia a dia.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "isInstructor": false,
      "replies": [
        {
          "userName": "Prof. John Smith",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "content":
              "Fico feliz que tenha gostado, Maria! Continue praticando e logo estará conversando fluentemente.",
          "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
          "isInstructor": true,
        }
      ]
    },
    {
      "id": 2,
      "userName": "Carlos Oliveira",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "Tenho dificuldade com a pronúncia de algumas palavras. Vocês poderiam adicionar mais exercícios de áudio?",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "isInstructor": false,
      "replies": [
        {
          "userName": "Prof. John Smith",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "content":
              "Ótima sugestão, Carlos! Estamos trabalhando em mais exercícios de pronúncia. Enquanto isso, recomendo usar o botão de áudio em cada vocabulário.",
          "timestamp": DateTime.now().subtract(const Duration(hours: 18)),
          "isInstructor": true,
        }
      ]
    }
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked
            ? 'Lição salva nos favoritos!'
            : 'Lição removida dos favoritos!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareLesson() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link da lição copiado para a área de transferência!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startLesson() {
    Navigator.pushNamed(context, '/practice-hub-screen');
  }

  void _downloadForOffline() {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    // Simulate download progress
    _simulateDownload();
  }

  void _simulateDownload() {
    const duration = Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      setState(() {
        _downloadProgress += 0.05;
      });

      if (_downloadProgress >= 1.0) {
        timer.cancel();
        setState(() {
          _isDownloading = false;
          _downloadProgress = 1.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lição baixada com sucesso para uso offline!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _playVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reproduzindo vídeo da lição...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _playVocabularyAudio(String word) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reproduzindo pronúncia de "$word"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTranscriptBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h),
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Text(
                      'Transcrição da Lição',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 24,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    """Olá e bem-vindos à nossa lição sobre conversação básica em inglês!

Hoje vamos aprender como se apresentar e manter uma conversa simples em inglês. Começaremos com cumprimentos básicos.

A primeira palavra que vamos aprender é "Hello" - que significa "Olá" em português. É uma das formas mais comuns de cumprimentar alguém.

Quando conhecemos alguém pela primeira vez, podemos dizer "Nice to meet you" - que significa "Prazer em conhecê-lo".

Uma pergunta muito comum em conversas é "Where are you from?" - "De onde você é?". Esta é uma ótima maneira de conhecer melhor a pessoa.

E sempre lembre-se de ser educado e dizer "Thank you" - "Obrigado" - quando alguém te ajudar ou fizer algo gentil.

Vamos praticar essas expressões juntos!""",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back_ios',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            title: Text(
              'Detalhes da Lição',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showTranscriptBottomSheet,
                icon: CustomIconWidget(
                  iconName: 'subtitles',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Lesson Header
                LessonHeaderWidget(
                  title: lessonData['title'] as String,
                  difficulty: lessonData['difficulty'] as String,
                  duration: lessonData['duration'] as String,
                  completionPercentage:
                      lessonData['completionPercentage'] as double,
                  isBookmarked: _isBookmarked,
                  onBookmarkTap: _toggleBookmark,
                  onShareTap: _shareLesson,
                ),

                // Video Player
                LessonVideoWidget(
                  videoThumbnail: lessonData['videoThumbnail'] as String,
                  videoTitle: lessonData['videoTitle'] as String,
                  videoDuration: lessonData['videoDuration'] as String,
                  onPlayTap: _playVideo,
                ),

                // Lesson Objectives
                ExpandableSectionWidget(
                  title: 'Objetivos da Lição',
                  icon: Icons.flag_outlined,
                  initiallyExpanded: true,
                  content: Column(
                    children: (lessonData['objectives'] as List<String>)
                        .map((objective) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                objective,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Vocabulary Section
                ExpandableSectionWidget(
                  title:
                      'Vocabulário (${(lessonData['vocabulary'] as List).length} palavras)',
                  icon: Icons.book_outlined,
                  content: Column(
                    children:
                        (lessonData['vocabulary'] as List<Map<String, dynamic>>)
                            .map((vocab) {
                      return VocabularyItemWidget(
                        word: vocab['word'] as String,
                        translation: vocab['translation'] as String,
                        pronunciation: vocab['pronunciation'] as String,
                        example: vocab['example'] as String,
                        onPlayAudio: () =>
                            _playVocabularyAudio(vocab['word'] as String),
                      );
                    }).toList(),
                  ),
                ),

                // Grammar Points
                ExpandableSectionWidget(
                  title: 'Pontos Gramaticais',
                  icon: Icons.school_outlined,
                  content: Column(
                    children: (lessonData['grammarPoints'] as List<String>)
                        .map((point) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 2.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'lightbulb_outline',
                              size: 20,
                              color: AppTheme.lightTheme.colorScheme.secondary,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                point,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Prerequisites
                if (prerequisiteLessons.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lições Pré-requisito',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 4.w),
                            itemCount: prerequisiteLessons.length,
                            itemBuilder: (context, index) {
                              final lesson = prerequisiteLessons[index];
                              return PrerequisiteCardWidget(
                                title: lesson['title'] as String,
                                difficulty: lesson['difficulty'] as String,
                                isCompleted: lesson['isCompleted'] as bool,
                                completionPercentage:
                                    lesson['completionPercentage'] as double,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Navegando para: ${lesson['title']}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // User Progress
                UserProgressWidget(
                  attempts: userAttempts,
                  totalTimeSpent: userAttempts.fold(
                      0, (sum, attempt) => sum + (attempt['timeSpent'] as int)),
                  averageScore: userAttempts.fold(
                          0.0,
                          (sum, attempt) =>
                              sum + (attempt['score'] as double)) /
                      userAttempts.length,
                ),

                // Comments Section
                CommentsSectionWidget(
                  comments: comments,
                  onAddComment: () {
                    // Handle add comment
                  },
                ),

                SizedBox(height: 10.h), // Space for floating buttons
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _startLesson,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: CustomIconWidget(
              iconName: 'play_arrow',
              size: 24,
              color: Colors.white,
            ),
            label: Text(
              'Iniciar Lição',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          FloatingActionButton.extended(
            onPressed: _downloadForOffline,
            backgroundColor: _isDownloading
                ? AppTheme.lightTheme.colorScheme.outline
                : AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: _isDownloading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      value: _downloadProgress,
                      strokeWidth: 2,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : CustomIconWidget(
                    iconName:
                        _downloadProgress >= 1.0 ? 'download_done' : 'download',
                    size: 24,
                    color: Colors.white,
                  ),
            label: Text(
              _isDownloading
                  ? 'Baixando... ${(_downloadProgress * 100).toInt()}%'
                  : _downloadProgress >= 1.0
                      ? 'Baixado'
                      : 'Baixar Offline',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}