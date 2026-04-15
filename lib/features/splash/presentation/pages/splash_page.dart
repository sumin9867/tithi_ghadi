import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tithi_gadhi/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:tithi_gadhi/features/splash/presentation/cubit/splash_state.dart';
import '../../../../core/di/injection.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..checkToken(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            authenticated: () {
              context.go('/home'); // Home page will be implemented later
            },
            unauthenticated: () {
              context.go('/login');
            },
          );
        },
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.spa, size: 100, color: Colors.deepPurple),
                SizedBox(height: 24),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
