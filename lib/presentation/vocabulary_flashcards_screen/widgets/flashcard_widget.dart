import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FlashcardWidget extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onFlip;
  final bool isFlipped;
  final bool showHint;

  const FlashcardWidget({
    super.key,
    required this.cardData,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onFlip,
    this.isFlipped = false,
    this.showHint = false,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _swipeController;
  late Animation<double> _flipAnimation;
  late Animation<Offset> _swipeAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _swipeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.easeInOut));

    _swipeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    const double threshold = 100.0;

    if (_dragOffset.dx > threshold) {
      // Swipe right - Know it
      _animateSwipeOut(true);
      HapticFeedback.lightImpact();
      widget.onSwipeRight?.call();
    } else if (_dragOffset.dx < -threshold) {
      // Swipe left - Review again
      _animateSwipeOut(false);
      HapticFeedback.lightImpact();
      widget.onSwipeLeft?.call();
    } else if (_dragOffset.dy < -threshold) {
      // Swipe up - Flip card
      widget.onFlip?.call();
      HapticFeedback.selectionClick();
    } else {
      // Return to center
      _resetPosition();
    }
  }

  void _animateSwipeOut(bool isRight) {
    _swipeAnimation = Tween<Offset>(
            begin: _dragOffset,
            end: Offset(isRight ? 400.0 : -400.0, _dragOffset.dy))
        .animate(
            CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    _swipeController.forward().then((_) {
      _resetPosition();
    });
  }

  void _resetPosition() {
    setState(() {
      _dragOffset = Offset.zero;
      _isDragging = false;
    });
    _swipeController.reset();
  }

  void _playAudio() {
    // Audio playback implementation would go here
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reproduzindo áudio: ${widget.cardData["word"]}'),
        duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        onTap: widget.onFlip,
        child: AnimatedBuilder(
            animation: Listenable.merge([_flipAnimation, _swipeAnimation]),
            builder: (context, child) {
              return Transform.translate(
                  offset: _isDragging ? _dragOffset : _swipeAnimation.value,
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_flipAnimation.value * 3.14159),
                      child: Container(
                          width: 85.w,
                          height: 60.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: colorScheme.shadow
                                        .withValues(alpha: 0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8)),
                              ]),
                          child: _flipAnimation.value < 0.5
                              ? _buildFrontCard(context)
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(3.14159),
                                  child: _buildBackCard(context)))));
            }));
  }

  Widget _buildFrontCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2), width: 1)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Language flag or category icon
          Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: CustomIconWidget(
                  iconName: 'translate',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 8.w)),

          SizedBox(height: 4.h),

          // Main word
          Text(
              widget.showHint
                  ? _getHintText(widget.cardData["word"] as String)
                  : widget.cardData["word"] as String,
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),

          SizedBox(height: 2.h),

          // Phonetic pronunciation
          if (widget.cardData["phonetic"] != null)
            Text(widget.cardData["phonetic"] as String,
                style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center),

          SizedBox(height: 3.h),

          // Audio play button
          ElevatedButton.icon(
              onPressed: _playAudio,
              icon: CustomIconWidget(
                  iconName: 'volume_up',
                  color: colorScheme.onPrimary,
                  size: 5.w),
              label: Text('Ouvir'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)))),

          SizedBox(height: 4.h),

          // Swipe instructions
          Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8)),
              child: Text('Deslize ↑ para virar • ← Revisar • → Sei',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center)),
        ]));
  }

  Widget _buildBackCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1)),
        padding: EdgeInsets.all(6.w),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Translation
          Text('Tradução',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),

          SizedBox(height: 2.h),

          Text(widget.cardData["translation"] as String,
              style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),

          SizedBox(height: 3.h),

          // Example sentence
          if (widget.cardData["example"] != null) ...[
            Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        width: 1)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exemplo:',
                          style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 1.h),
                      Text(widget.cardData["example"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontStyle: FontStyle.italic)),
                      if (widget.cardData["exampleTranslation"] != null) ...[
                        SizedBox(height: 1.h),
                        Text(widget.cardData["exampleTranslation"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                      ],
                    ])),
            SizedBox(height: 3.h),
          ],

          // Usage context
          if (widget.cardData["context"] != null)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('Contexto: ${widget.cardData["context"]}',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center)),
        ]));
  }

  String _getHintText(String word) {
    if (word.length <= 2) return word;
    return '${word.substring(0, 2)}${'_' * (word.length - 2)}';
  }
}
