import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ConfidenceSliderWidget extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double>? onChanged;
  final VoidCallback? onSubmit;
  final bool isVisible;

  const ConfidenceSliderWidget({
    super.key,
    this.initialValue = 0.5,
    this.onChanged,
    this.onSubmit,
    this.isVisible = false,
  });

  @override
  State<ConfidenceSliderWidget> createState() => _ConfidenceSliderWidgetState();
}

class _ConfidenceSliderWidgetState extends State<ConfidenceSliderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ConfidenceSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  String _getConfidenceLabel(double value) {
    if (value < 0.2) return 'Muito Difícil';
    if (value < 0.4) return 'Difícil';
    if (value < 0.6) return 'Médio';
    if (value < 0.8) return 'Fácil';
    return 'Muito Fácil';
  }

  Color _getConfidenceColor(double value) {
    if (value < 0.2) return AppTheme.errorLight;
    if (value < 0.4) return AppTheme.warningLight;
    if (value < 0.6) return AppTheme.lightTheme.colorScheme.secondary;
    if (value < 0.8) return AppTheme.successLight;
    return AppTheme.lightTheme.primaryColor;
  }

  String _getConfidenceIcon(double value) {
    if (value < 0.2) return 'sentiment_very_dissatisfied';
    if (value < 0.4) return 'sentiment_dissatisfied';
    if (value < 0.6) return 'sentiment_neutral';
    if (value < 0.8) return 'sentiment_satisfied';
    return 'sentiment_very_satisfied';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(0, (1 - _slideAnimation.value) * 100),
              child: Opacity(
                  opacity: _slideAnimation.value,
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    colorScheme.shadow.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4)),
                          ],
                          border: Border.all(
                              color: _getConfidenceColor(_currentValue)
                                  .withValues(alpha: 0.3),
                              width: 1)),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        // Header with icon and title
                        Row(children: [
                          Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                  color: _getConfidenceColor(_currentValue)
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle),
                              child: CustomIconWidget(
                                  iconName: _getConfidenceIcon(_currentValue),
                                  color: _getConfidenceColor(_currentValue),
                                  size: 6.w)),
                          SizedBox(width: 3.w),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Como foi essa palavra?',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600)),
                                Text(
                                    'Isso ajuda a personalizar sua experiência',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant)),
                              ])),
                        ]),

                        SizedBox(height: 3.h),

                        // Confidence level display
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                                color: _getConfidenceColor(_currentValue)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(_getConfidenceLabel(_currentValue),
                                style: theme.textTheme.titleLarge?.copyWith(
                                    color: _getConfidenceColor(_currentValue),
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center)),

                        SizedBox(height: 3.h),

                        // Slider
                        SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    _getConfidenceColor(_currentValue),
                                thumbColor: _getConfidenceColor(_currentValue),
                                overlayColor: _getConfidenceColor(_currentValue)
                                    .withValues(alpha: 0.2),
                                inactiveTrackColor:
                                    colorScheme.outline.withValues(alpha: 0.3),
                                trackHeight: 6,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 12),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 20)),
                            child: Slider(
                                value: _currentValue,
                                onChanged: (value) {
                                  setState(() {
                                    _currentValue = value;
                                  });
                                  HapticFeedback.selectionClick();
                                  widget.onChanged?.call(value);
                                },
                                divisions: 4)),

                        // Slider labels
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Muito\nDifícil',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.errorLight),
                                      textAlign: TextAlign.center),
                                  Text('Médio',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(),
                                      textAlign: TextAlign.center),
                                  Text('Muito\nFácil',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme
                                                  .lightTheme.primaryColor),
                                      textAlign: TextAlign.center),
                                ])),

                        SizedBox(height: 3.h),

                        // Submit button
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  widget.onSubmit?.call();
                                },
                                icon: CustomIconWidget(
                                    iconName: 'check',
                                    color: Colors.white,
                                    size: 5.w),
                                label: Text('Confirmar'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _getConfidenceColor(_currentValue),
                                    foregroundColor: Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))))),
                      ]))));
        });
  }
}