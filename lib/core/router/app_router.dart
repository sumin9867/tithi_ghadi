import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tithi_gadhi/features/onboarding/presentation/onboarding_screen.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_shell.dart';
import '../../features/home/presentation/pages/tithi_ghadi_screen.dart';
import '../../features/home/presentation/pages/calendar_screen.dart';
import '../../features/home/presentation/pages/alerts_screen.dart';
import '../../features/home/presentation/pages/settings_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';

/// ✅ Centralized route definitions
class AppRoute {
  static const splash = '/';
  static const login = '/login';

  // shell routes
  static const homeRoot = '/home';
  static const homeTithi = '/home/tithi';
  static const homeCalendar = '/home/calendar';
  static const homeAlerts = '/home/alerts';
  static const homeSettings = '/home/settings';
  static const onboarding = '/onBoarding';


  // outside shell
  static const profile = '/profile';
}

@lazySingleton
class AppRouter {
  final FlutterSecureStorage secureStorage;

  AppRouter(this.secureStorage);

  late final GoRouter config = GoRouter(
    initialLocation: AppRoute.splash,

    /// ✅ Cleaner redirect logic
    // redirect: (context, state) async {
    //   final path = state.uri.path;

    //   final isSplash = path == AppRoute.splash;
    //   final isLogin = path == AppRoute.login;

    //   if (isSplash) return null;

    //   final token = await secureStorage.read(key: 'auth_token');
    //   final isLoggedIn = token != null && token.isNotEmpty;

    //   /// 🔥 Fix: handle `/home`
    //   if (path == AppRoute.homeRoot) {
    //     return AppRoute.homeTithi;
    //   }

    //   if (!isLoggedIn && !isLogin) {
    //     return AppRoute.login;
    //   }

    //   if (isLoggedIn && isLogin) {
    //     return AppRoute.homeTithi;
    //   }

    //   return null;
    // },

    routes: [
      /// Splash
      GoRoute(
        path: AppRoute.splash,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: AppRoute.onboarding,
        builder: (context, state) => const OnboardingFlow(),
      ),

      /// Login
      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginPage(),
      ),

      /// 🔥 `/home` alias fix
      GoRoute(
        path: AppRoute.homeRoot,
        redirect: (_, __) => AppRoute.homeTithi,
      ),

      /// ✅ ShellRoute (persistent bottom nav)
      ShellRoute(
        builder: (context, state, child) {
          return HomeShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.homeTithi,
            builder: (context, state) => const TithiGhadiScreen(),
          ),
          GoRoute(
            path: AppRoute.homeCalendar,
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: AppRoute.homeAlerts,
            builder: (context, state) => const AlertsScreen(),
          ),
          GoRoute(
            path: AppRoute.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      /// Outside bottom nav
     
    ],
  );
}