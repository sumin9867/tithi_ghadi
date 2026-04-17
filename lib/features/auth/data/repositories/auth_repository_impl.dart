import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/error/failures.dart';
import 'package:tithi_gadhi/core/services/secure_storage_service.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;
  final GoogleSignIn _googleSignIn;
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _fcm;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._storage,
    this._googleSignIn,
    this._firebaseAuth,
    this._fcm,
  );

  @override
  Future<Either<Failure, User>> appStarted() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return const Left(Failure.unauthorizedFailure());

      final response = await _remoteDataSource.refreshToken(refreshToken);
      await _storage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresAt: response.expiresAt,
      );
      return Right(_mapToUser(response.user));
    } catch (e) {
      // Per requirements: If refresh fails (401/expired), clear storage and redirect to login
      await logout();
      return Left(Failure.unauthorizedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const Left(Failure.unauthorizedFailure('Google sign in cancelled'));

      final googleAuth = await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) return const Left(Failure.serverFailure('Failed to get ID Token'));

      final fcmToken = await _fcm.getToken();
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = '';
      String deviceName = '';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceName = iosInfo.name;
      }

      final response = await _remoteDataSource.signInWithFirebase(
        idToken: idToken,
        fcmToken: fcmToken ?? '',
        deviceId: deviceId,
        deviceName: deviceName,
      );

      await _storage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresAt: response.expiresAt,
      );

      return Right(_mapToUser(response.user));
    } catch (e) {
      return Left(Failure.serverFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // 1. Inform backend
      final accessToken = await _storage.getAccessToken();
      if (accessToken != null) {
        try {
          await _remoteDataSource.logout();
        } catch (_) {}
      }

      // 2. Clean up local services
      try {
        await FlutterForegroundTask.stopService();
      } catch (_) {}

      // 3. Clear storage
      await _storage.clearAll();

      // 4. Firebase + Google sign out
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverFailure(e.toString()));
    }
  }

  User _mapToUser(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      name: model.name,
      pictureUrl: model.pictureUrl,
    );
  }
}
