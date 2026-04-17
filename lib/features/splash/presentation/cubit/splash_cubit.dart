import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tithi_gadhi/core/services/secure_storage_service.dart';
import 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final SecureStorageService _storage;
  final SharedPreferences _prefs;

  SplashCubit(this._storage, this._prefs) : super(const SplashState.initial());

  Future<void> checkInitialStatus() async {
    // 1. Minimum splash delay for branding
    await Future.delayed(const Duration(seconds: 2));

    // 2. Check Onboarding
    final isOnboardingDone = _prefs.getBool('isOnboardingDone') ?? false;
    if (!isOnboardingDone) {
      emit(const SplashState.needsOnboarding());
      return;
    }

    // 3. Check for existing session (refreshToken)
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      emit(const SplashState.authenticated());
    } else {
      emit(const SplashState.unauthenticated());
    }
  }
}
