import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/network/dio_client.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signInWithFirebase({
    required String idToken,
    required String fcmToken,
    required String deviceId,
    required String deviceName,
  });

  Future<AuthResponseModel> refreshToken(String refreshToken);

  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<AuthResponseModel> signInWithFirebase({
    required String idToken,
    required String fcmToken,
    required String deviceId,
    required String deviceName,
  }) async {
    final response = await _dio.post(
      '/api/mobile-auth/firebase',
      data: {
        'idToken': idToken,
        'fcmToken': fcmToken,
        'deviceId': deviceId,
        'deviceName': deviceName,
      },
    );
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/api/mobile-auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await _dio.post('/api/mobile-auth/logout');
  }
}
