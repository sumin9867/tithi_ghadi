import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Onboarding Flow (PageView with 3 screens) ───────────────────────────────

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = GetIt.instance.get<SharedPreferences>();
    await prefs.setBool('isOnboardingDone', true);
    if (mounted) context.go('/login');
  }

  void _next() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _currentPage = i),
        children: [
          OnboardingScreen(
            page: 0,
            illustrationAsset: 'assets/onboarding/on_1.svg',
            isLast: false,
            onNext: _next,
            onSkip: _completeOnboarding,
            currentPage: _currentPage,
          ),
          OnboardingScreen(
            page: 1,
            illustrationAsset: 'assets/onboarding/on_2.svg',
            isLast: false,
            onNext: _next,
            onSkip: _completeOnboarding,
            currentPage: _currentPage,
          ),
          OnboardingScreen(
            page: 2,
            illustrationAsset: 'assets/onboarding/on_3.svg',
            isLast: true,
            onNext: _next,
            onSkip: _completeOnboarding,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }
}

// ─── Single Onboarding Screen ─────────────────────────────────────────────────

class OnboardingScreen extends StatelessWidget {
  final int page;
  final int currentPage;
  final String illustrationAsset;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingScreen({
    super.key,
    required this.page,
    required this.currentPage,
    required this.illustrationAsset,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ── Logo ────────────────────────────────────────────────────────
            Image.asset(
              'assets/onboarding/panchang.png',
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 16),

            // ── Title ────────────────────────────────────────────────────────
            const Text(
              'Tithi Ghadi',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '"Follow the right clock."',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFAAAAAA),
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 36),

            // ── SVG Illustration ─────────────────────────────────────────────
            Expanded(
              child: SvgPicture.asset(illustrationAsset, fit: BoxFit.contain),
            ),

            const SizedBox(height: 28),

            // ── Description ──────────────────────────────────────────────────
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCCCCCC),
                  height: 1.6,
                ),
                children: [
                  TextSpan(
                    text: 'Real time Tithi with less hassle in your own ',
                  ),
                  TextSpan(
                    text: 'hand.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Dot Indicators ───────────────────────────────────────────────
            DotIndicators(currentPage: currentPage, total: 3),

            const SizedBox(height: 28),

            // ── Primary Button (Next / Get Started) ──────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.03, 0.12),
                    end: Alignment(0.97, 1.00),
                    colors: [Color(0xFF0C9AB2), Color(0xFFF0CA53)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Skip Button ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onSkip,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 15, color: Color(0xFFAAAAAA)),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Dot Indicators ──────────────────────────────────────────────────────────

class DotIndicators extends StatelessWidget {
  final int currentPage;
  final int total;

  const DotIndicators({
    super.key,
    required this.currentPage,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? null : const Color(0xFF555555),
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF4A9D7A), Color(0xFF6DC8A0)],
                  )
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
