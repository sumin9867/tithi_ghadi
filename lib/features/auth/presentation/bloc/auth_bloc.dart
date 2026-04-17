import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/features/auth/domain/repositories/auth_repository.dart';
import 'package:tithi_gadhi/features/auth/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        appStarted: () async {
          emit(const AuthState.loading());
          final result = await _repository.appStarted();
          result.fold(
            (failure) => emit(const AuthState.unauthenticated()),
            (user) => emit(AuthState.authenticated(user)),
          );
        },
        googleLoginRequested: () async {
          emit(const AuthState.loading());
          final result = await _repository.loginWithGoogle();
          result.fold(
            (failure) => emit(AuthState.error(_mapFailureToMessage(failure))),
            (user) => emit(AuthState.authenticated(user)),
          );
        },
        logoutRequested: () async {
          emit(const AuthState.loading());
          await _repository.logout();
          emit(const AuthState.unauthenticated());
        },
      );
    });
  }



  String _mapFailureToMessage(dynamic failure) {
    return failure.maybeMap(
      serverFailure: (f) => f.message ?? 'Server error occurred',
      unauthorizedFailure: (f) => f.message ?? 'Unauthorized',
      networkFailure: (f) => f.message ?? 'Network error',
      orElse: () => 'Unexpected error occurred',
    );
  }
}
