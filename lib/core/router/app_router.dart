import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';

class AppRoute {
  final String splashRoute = '/';
  final String loginRoute = '/login';
  final String homeRoute = '/home';
  final String profileRoute = '/profile';
}

@lazySingleton
class AppRouter {
  final FlutterSecureStorage secureStorage;

  AppRouter(this.secureStorage);

  late final GoRouter config = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final path = state.uri.path;
      final isLoggingIn = path == AppRoute().loginRoute;
      final isSplash = path == '/';

      if (isSplash) return null;

      final token = await secureStorage.read(key: 'auth_token');
      final isLoggedIn = token != null && token.isNotEmpty;

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
