part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.appStarted() = _AppStarted;
  const factory AuthEvent.googleLoginRequested() = _GoogleLoginRequested;
  const factory AuthEvent.logoutRequested() = _LogoutRequested;
}
