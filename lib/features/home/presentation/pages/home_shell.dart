import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:tithi_gadhi/core/router/app_router.dart';
import 'package:tithi_gadhi/features/home/presentation/models/home_models.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  /// ✅ Navigation config
 static const List<NavigationItem> _navItems = [
    NavigationItem(
      label: 'Home',
      icon: IconsaxPlusLinear.home_1,
      activeIcon: IconsaxPlusBold.home_1,
      route: AppRoute.homeTithi,
    ),
    NavigationItem(
      label: 'Calendar',
      icon: IconsaxPlusLinear.calendar_1,
      activeIcon: IconsaxPlusBold.calendar_1,
      route: AppRoute.homeCalendar,
    ),
    NavigationItem(
      label: 'Alerts',
      icon: IconsaxPlusLinear.notification_1,
      activeIcon: IconsaxPlusBold.notification_1,
      route: AppRoute.homeAlerts,
    ),
    NavigationItem(
      label: 'Settings',
      icon: IconsaxPlusLinear.setting_2,
      activeIcon: IconsaxPlusBold.setting_2,
      route: AppRoute.profile, // ✅ FIXED
    ),
  ];



  /// ✅ Better route matching (no false positives)
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    for (int i = 0; i < _navItems.length; i++) {
      final route = _navItems[i].route;

      if (location == route || location.startsWith('$route/')) {
        return i;
      }
    }
    return 0;
  }

  /// ✅ Safe navigation (no duplicate calls)
  void _onTap(BuildContext context, String route) {
    final current = GoRouterState.of(context).uri.toString();

    if (current != route) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      backgroundColor: kBg0,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kBg1,
          border: Border(
            top: BorderSide(
              color: kSlate.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GNav(
              selectedIndex: selectedIndex,
              onTabChange: (index) =>
                  _onTap(context, _navItems[index].route),

              backgroundColor: kBg1,
              color: kSlate,
              activeColor: kGold,
              tabBackgroundColor: kGold.withValues(alpha: 0.15),

              gap: 8,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              duration: const Duration(milliseconds: 300),
              tabBorderRadius: 14,

              tabs: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isActive = index == selectedIndex;

                return GButton(
                  icon: isActive ? item.activeIcon : item.icon,
                  text: item.label,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kGold,
                    letterSpacing: 0.3,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ Immutable model
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}