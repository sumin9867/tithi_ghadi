import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final PushNotificationService pushNotificationService;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.secureStorage,
    this.pushNotificationService,
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await secureStorage.write(key: 'auth_token', value: userModel.token);
      return Right(userModel.toDomain());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(
          Failure.unauthorizedFailure('Invalid email or password'),
        );
      }
      return const Left(
        Failure.serverFailure('An error occurred during login.'),
      );
    } catch (e) {
      return const Left(
        Failure.networkFailure(
          'Please check your internet connection and try again.',
        ),
      );
    }
  }



  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      final userModel = await remoteDataSource.loginWithGoogle();
      await secureStorage.write(key: 'auth_token', value: userModel.token);
      // Fire-and-forget: register device with FCM token
      unawaited(_registerDevice(userModel.token));
      return Right(userModel.toDomain());
    } catch (e) {
      return const Left(Failure.serverFailure('Failed to login with Google.'));
    }
  }

  Future<void> _registerDevice(String idToken) async {
    try {
      final fcmToken = FcmService().fcmToken;
      if (fcmToken == null || idToken.isEmpty) return;
      await pushNotificationService.registerDeviceWithBackend(
        idToken: idToken,
        fcmToken: fcmToken,
      );
    } catch (_) {
      // Silent fail - device registration failure shouldn't block login
    }
  }
}
