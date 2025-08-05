import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data class for bottom navigation
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar implementing Contemporary Educational Minimalism
/// Provides adaptive tab navigation with consistent styling and smooth transitions
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Whether to use Material 3 NavigationBar (default) or legacy BottomNavigationBar
  final bool useMaterial3;

  /// Custom background color
  final Color? backgroundColor;

  /// Whether to show labels
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.useMaterial3 = true,
    this.backgroundColor,
    this.showLabels = true,
  });

  /// Predefined navigation items for the educational app
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/dashboard-screen',
    ),
    NavigationItem(
      label: 'Lessons',
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
      route: '/lesson-detail-screen',
    ),
    NavigationItem(
      label: 'Practice',
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center,
      route: '/practice-hub-screen',
    ),
    NavigationItem(
      label: 'Vocabulary',
      icon: Icons.quiz_outlined,
      activeIcon: Icons.quiz,
      route: '/vocabulary-flashcards-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (useMaterial3) {
      return _buildMaterial3NavigationBar(context);
    } else {
      return _buildLegacyBottomNavigationBar(context);
    }
  }

  /// Build Material 3 NavigationBar
  Widget _buildMaterial3NavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex.clamp(0, _navigationItems.length - 1),
      onDestinationSelected: (index) {
        if (onTap != null) {
          onTap!(index);
        } else {
          _navigateToRoute(context, _navigationItems[index].route);
        }
      },
      backgroundColor: backgroundColor ?? colorScheme.surface,
      indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
      elevation: 8.0,
      height: 80,
      labelBehavior: showLabels
          ? NavigationDestinationLabelBehavior.alwaysShow
          : NavigationDestinationLabelBehavior.alwaysHide,
      destinations: _navigationItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == currentIndex;

        return NavigationDestination(
          icon: Icon(
            item.icon,
            color:
                isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          selectedIcon: Icon(
            item.activeIcon ?? item.icon,
            color: colorScheme.primary,
          ),
          label: item.label,
        );
      }).toList(),
    );
  }

  /// Build legacy BottomNavigationBar
  Widget _buildLegacyBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex.clamp(0, _navigationItems.length - 1),
      onTap: (index) {
        if (onTap != null) {
          onTap!(index);
        } else {
          _navigateToRoute(context, _navigationItems[index].route);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      elevation: 8.0,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      items: _navigationItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == currentIndex;

        return BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Icon(
              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
              size: 24,
            ),
          ),
          label: item.label,
          tooltip: item.label,
        );
      }).toList(),
    );
  }

  /// Navigate to the specified route
  void _navigateToRoute(BuildContext context, String route) {
    // Get current route name
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Only navigate if not already on the target route
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false, // Remove all previous routes
      );
    }
  }

  /// Factory constructor for dashboard bottom bar
  factory CustomBottomBar.dashboard({
    required int currentIndex,
    ValueChanged<int>? onTap,
    bool useMaterial3 = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      useMaterial3: useMaterial3,
      showLabels: true,
    );
  }

  /// Factory constructor for minimal bottom bar (icons only)
  factory CustomBottomBar.minimal({
    required int currentIndex,
    ValueChanged<int>? onTap,
    bool useMaterial3 = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      useMaterial3: useMaterial3,
      showLabels: false,
    );
  }

  /// Get navigation item by route
  static NavigationItem? getItemByRoute(String route) {
    try {
      return _navigationItems.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }

  /// Get index by route
  static int getIndexByRoute(String route) {
    for (int i = 0; i < _navigationItems.length; i++) {
      if (_navigationItems[i].route == route) {
        return i;
      }
    }
    return 0; // Default to first item
  }

  /// Get all navigation routes
  static List<String> get allRoutes {
    return _navigationItems.map((item) => item.route).toList();
  }
}
