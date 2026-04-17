import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/config/env_config.dart';
import 'package:tithi_gadhi/core/network/auth_interceptor.dart';

@lazySingleton
class DioClient {
  final Dio _dio;
  final AuthInterceptor _authInterceptor;

  DioClient(this._dio, this._authInterceptor) {
    _dio
      ..options.baseUrl = EnvConfig.apiBaseUrl
      ..options.connectTimeout = Duration(seconds: EnvConfig.apiTimeout)
      ..options.receiveTimeout = Duration(seconds: EnvConfig.apiTimeout)
      ..interceptors.addAll([
        _authInterceptor,
        ErrorInterceptor(),
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }

  Dio get dio => _dio;
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle global errors like 500, etc.
    // 401 is now handled by AuthInterceptor
    super.onError(err, handler);
  }
}
