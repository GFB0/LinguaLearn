import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data class for custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final String? route;
  final VoidCallback? onTap;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.route,
    this.onTap,
  });
}

/// Custom Tab Bar implementing Contemporary Educational Minimalism
/// Provides clean, focused tab navigation with smooth transitions
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab items
  final List<TabItem> tabs;

  /// Tab controller
  final TabController? controller;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom label color
  final Color? labelColor;

  /// Custom unselected label color
  final Color? unselectedLabelColor;

  /// Whether to show icons
  final bool showIcons;

  /// Tab alignment for scrollable tabs
  final TabAlignment tabAlignment;

  /// Padding around tabs
  final EdgeInsetsGeometry? padding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.showIcons = false,
    this.tabAlignment = TabAlignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding,
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildTab(context, tab)).toList(),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: labelColor ?? colorScheme.primary,
        unselectedLabelColor:
            unselectedLabelColor ?? colorScheme.onSurfaceVariant,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.04);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.08);
          }
          return null;
        }),
        splashFactory: InkRipple.splashFactory,
        onTap: (index) {
          final tab = tabs[index];
          if (tab.onTap != null) {
            tab.onTap!();
          } else if (tab.route != null) {
            Navigator.pushNamed(context, tab.route!);
          }
        },
      ),
    );
  }

  /// Build individual tab widget
  Widget _buildTab(BuildContext context, TabItem tab) {
    if (showIcons && (tab.icon != null || tab.customIcon != null)) {
      return Tab(
        icon: tab.customIcon ?? Icon(tab.icon, size: 20),
        text: tab.label,
        iconMargin: const EdgeInsets.only(bottom: 4),
      );
    } else {
      return Tab(
        text: tab.label,
        height: 48,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);

  /// Factory constructor for lesson categories tab bar
  factory CustomTabBar.lessonCategories({
    TabController? controller,
    bool isScrollable = true,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomTabBar(
      controller: controller,
      isScrollable: isScrollable,
      tabAlignment: TabAlignment.start,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      tabs: const [
        TabItem(label: 'All Lessons'),
        TabItem(label: 'Grammar'),
        TabItem(label: 'Vocabulary'),
        TabItem(label: 'Pronunciation'),
        TabItem(label: 'Conversation'),
        TabItem(label: 'Writing'),
      ],
    );
  }

  /// Factory constructor for practice types tab bar
  factory CustomTabBar.practiceTypes({
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomTabBar(
      controller: controller,
      isScrollable: isScrollable,
      showIcons: true,
      padding: padding,
      tabs: const [
        TabItem(
          label: 'Flashcards',
          icon: Icons.quiz_outlined,
          route: '/vocabulary-flashcards-screen',
        ),
        TabItem(
          label: 'Speaking',
          icon: Icons.mic_outlined,
        ),
        TabItem(
          label: 'Listening',
          icon: Icons.headphones_outlined,
        ),
        TabItem(
          label: 'Writing',
          icon: Icons.edit_outlined,
        ),
      ],
    );
  }

  /// Factory constructor for progress tracking tab bar
  factory CustomTabBar.progressTracking({
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomTabBar(
      controller: controller,
      isScrollable: isScrollable,
      padding: padding,
      tabs: const [
        TabItem(label: 'Daily'),
        TabItem(label: 'Weekly'),
        TabItem(label: 'Monthly'),
        TabItem(label: 'All Time'),
      ],
    );
  }

  /// Factory constructor for language selection tab bar
  factory CustomTabBar.languageSelection({
    TabController? controller,
    bool isScrollable = true,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomTabBar(
      controller: controller,
      isScrollable: isScrollable,
      tabAlignment: TabAlignment.start,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      tabs: const [
        TabItem(label: 'Popular'),
        TabItem(label: 'European'),
        TabItem(label: 'Asian'),
        TabItem(label: 'All Languages'),
      ],
    );
  }

  /// Factory constructor for difficulty levels tab bar
  factory CustomTabBar.difficultyLevels({
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomTabBar(
      controller: controller,
      isScrollable: isScrollable,
      padding: padding,
      tabs: const [
        TabItem(label: 'Beginner'),
        TabItem(label: 'Intermediate'),
        TabItem(label: 'Advanced'),
      ],
    );
  }

  /// Factory constructor for achievement categories tab bar
  factory CustomTabBar.achievementCategories({
    TabController? controller,
    bool isScrollable = true,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomTabBar(
      controller: controller,
      isScrollable: isScrollable,
      tabAlignment: TabAlignment.start,
      showIcons: true,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      tabs: const [
        TabItem(
          label: 'Recent',
          icon: Icons.schedule_outlined,
        ),
        TabItem(
          label: 'Streaks',
          icon: Icons.local_fire_department_outlined,
        ),
        TabItem(
          label: 'Milestones',
          icon: Icons.emoji_events_outlined,
        ),
        TabItem(
          label: 'Badges',
          icon: Icons.military_tech_outlined,
        ),
      ],
    );
  }
}
