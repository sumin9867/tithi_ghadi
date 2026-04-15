import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/config/env_config.dart';

@lazySingleton
class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  DioClient(this._dio, this._secureStorage) {
    _dio
      ..options.baseUrl = EnvConfig.apiBaseUrl
      ..options.connectTimeout = Duration(seconds: EnvConfig.apiTimeout)
      ..options.receiveTimeout = Duration(seconds: EnvConfig.apiTimeout)
      ..interceptors.addAll([
        AuthInterceptor(_secureStorage),
        ErrorInterceptor(),
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }

  Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      options.headers['x-api-key'] =
          'tg-flutter-b2e5d8f1c4a73069e8b2d5f0c3a76e91';
    }
    super.onRequest(options, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle global errors like 401, 500, etc.
    if (err.response?.statusCode == 401) {
      // Trigger logout or refresh token logic
    }
    super.onError(err, handler);
  }
}
