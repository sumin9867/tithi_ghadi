import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/features/auth/presentation/cubit/auth_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/google_login_usecase.dart';
import '../domain/usecases/facebook_login_usecase.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final FacebookLoginUseCase _facebookLoginUseCase;

  AuthCubit(this._loginUseCase, this._googleLoginUseCase, this._facebookLoginUseCase) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    _handleResult(result);
  }

  Future<void> loginWithGoogle() async {
    emit(const AuthState.loading());
    final result = await _googleLoginUseCase(NoParams());
    _handleResult(result);
  }

  Future<void> loginWithFacebook() async {
    emit(const AuthState.loading());
    final result = await _facebookLoginUseCase(NoParams());
    _handleResult(result);
  }

  void _handleResult(dynamic result) {
    result.fold((failure) {
      String message = 'Unexpected error';
      failure.maybeWhen(
        unauthorizedFailure: (msg) => message = msg ?? 'Unauthorized',
        serverFailure: (msg) => message = msg ?? 'Server error',
        networkFailure: (msg) => message = msg ?? 'Network error',
        orElse: () {},
      );
      emit(AuthState.error(message));
    }, (user) => emit(const AuthState.success()));
  }
}
