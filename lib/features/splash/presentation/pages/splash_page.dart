import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tithi_gadhi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tithi_gadhi/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:tithi_gadhi/features/splash/presentation/cubit/splash_state.dart';
import 'package:tithi_gadhi/core/services/tithi_foreground_service.dart';
import '../../../../core/di/injection.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SplashCubit>()..checkInitialStatus()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            state.whenOrNull(
              needsOnboarding: () => context.go('/onBoarding'),
              unauthenticated: () => context.go('/login'),
              authenticated: () {
                // Refresh session on app open
                context.read<AuthBloc>().add(const AuthEvent.appStarted());
              },
            );
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              authenticated: (user) async {
                await TithiForegroundService.startService();
                if (context.mounted) context.go('/home');
              },
              unauthenticated: () => context.go('/login'),
            );
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/app_logo.png", height: 80),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
