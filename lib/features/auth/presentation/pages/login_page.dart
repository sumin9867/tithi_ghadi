import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tithi_gadhi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tithi_gadhi/features/auth/presentation/cubit/auth_state.dart';
import 'package:tithi_gadhi/core/services/tithi_foreground_service.dart';
import '../../../../core/di/injection.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),

      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              success: () async {
                await TithiForegroundService.startService();
                if (context.mounted) context.go('/home');
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Stack(
              children: [
                // ── MAIN CONTENT ─────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/onboarding/panchang.png',
                                width: 64,
                                height: 64,
                              ),
                              const SizedBox(height: 16),

                              const Text(
                                'Tithi Ghadi',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                '"Follow the right clock."',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFAAAAAA),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),

                              const SizedBox(height: 32),

                              SizedBox(
                                height: 220,
                                child: SvgPicture.asset(
                                  "assets/onboarding/on_3.svg",
                                ),
                              ),

                              const SizedBox(height: 24),

                              const Text(
                                'Real time Tithi with less hassle in your own hand.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFCCCCCC),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── LOADING OVERLAY ─────────────────────
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),

      // ── BOTTOM SHEET ─────────────────────
      bottomSheet: SafeArea(
        top: false,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                border: Border(
                  top: BorderSide(width: 2, color: Color(0xFF464646)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xFF818181),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Sign In to your account',
                    style: TextStyle(
                      color: Color(0xFF1BC1DD),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Google Button
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => context.read<AuthCubit>().loginWithGoogle(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF464646),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/onboarding/google.svg",
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}