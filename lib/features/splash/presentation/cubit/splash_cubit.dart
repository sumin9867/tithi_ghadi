import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  SplashCubit(this._secureStorage, this._prefs) : super(const SplashState.initial());

  Future<void> checkToken() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash duration
    try {
      // Check if onboarding has been completed
      final isOnboardingDone = _prefs.getBool('isOnboardingDone') ?? false;
      if (!isOnboardingDone) {
        emit(const SplashState.needsOnboarding());
        return;
      }

      // Onboarding done, check auth status
      final token = await _secureStorage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        emit(const SplashState.authenticated());
      } else {
        emit(const SplashState.unauthenticated());
      }
    } catch (_) {
      emit(const SplashState.unauthenticated());
    }
  }
}
