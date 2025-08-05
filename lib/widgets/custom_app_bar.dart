import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Contemporary Educational Minimalism design
/// Provides clean, content-focused navigation with consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true if canPop is true)
  final bool showBackButton;

  /// Custom leading widget (overrides showBackButton if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether the app bar should have elevation shadow
  final bool hasElevation;

  /// Custom background color (uses theme color if not provided)
  final Color? backgroundColor;

  /// Custom text color (uses theme color if not provided)
  final Color? textColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (like TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.hasElevation = true,
    this.backgroundColor,
    this.textColor,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor ?? colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: textColor ?? colorScheme.onSurface,
      elevation: hasElevation ? 2.0 : 0.0,
      shadowColor: colorScheme.shadow,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
      bottom: bottom,
      shape: hasElevation
          ? null
          : const Border(
              bottom: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  /// Factory constructor for dashboard app bar with menu and profile actions
  factory CustomAppBar.dashboard({
    required String title,
    VoidCallback? onMenuPressed,
    VoidCallback? onProfilePressed,
    bool hasElevation = true,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: false,
      hasElevation: hasElevation,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications or show notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Notifications',
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: onProfilePressed ??
                () {
                  // Navigate to profile or show profile menu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile feature coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
            tooltip: 'Profile',
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for lesson detail app bar with progress indicator
  factory CustomAppBar.lessonDetail({
    required String title,
    required double progress,
    VoidCallback? onClosePressed,
    bool hasElevation = true,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: false,
      hasElevation: hasElevation,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClosePressed ?? () => Navigator.pop(context),
          tooltip: 'Close lesson',
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              return Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF4A261), // Secondary color
                          const Color(0xFFE76F51), // Secondary variant
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Factory constructor for practice hub app bar with timer
  factory CustomAppBar.practiceHub({
    required String title,
    Duration? timeRemaining,
    VoidCallback? onPausePressed,
    bool hasElevation = true,
  }) {
    return CustomAppBar(
      title: title,
      hasElevation: hasElevation,
      actions: [
        if (timeRemaining != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Builder(
              builder: (context) {
                final minutes = timeRemaining.inMinutes;
                final seconds = timeRemaining.inSeconds % 60;
                return Chip(
                  label: Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                );
              },
            ),
          ),
        if (onPausePressed != null)
          IconButton(
            icon: const Icon(Icons.pause_circle_outline),
            onPressed: onPausePressed,
            tooltip: 'Pause practice',
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}