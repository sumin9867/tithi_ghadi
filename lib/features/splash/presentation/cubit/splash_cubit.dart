import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final FlutterSecureStorage _secureStorage;

  SplashCubit(this._secureStorage) : super(const SplashState.initial());

  Future<void> checkToken() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash duration
    try {
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
