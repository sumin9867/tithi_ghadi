import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/services/secure_storage_service.dart';
import 'package:tithi_gadhi/core/config/env_config.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _refreshDio = Dio(BaseOptions(baseUrl: EnvConfig.apiBaseUrl));

  AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // Rate limit awareness placeholder (could add custom header if needed)
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Attempt one silent token refresh
          final response = await _refreshDio.post(
            '/api/mobile-auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final data = response.data;
            await _storage.saveTokens(
              accessToken: data['accessToken'],
              refreshToken: data['refreshToken'],
              expiresAt: data['expiresAt'],
            );

            // Retry the original request
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer ${data['accessToken']}';
            
            final retryResponse = await Dio(BaseOptions(baseUrl: options.baseUrl))
                .request(
              options.path,
              data: options.data,
              queryParameters: options.queryParameters,
              options: Options(
                method: options.method,
                headers: options.headers,
              ),
            );
            return handler.resolve(retryResponse);
          }
        } catch (refreshError) {
          // If refresh also fails (401/expired or Rate Limited 429)
          await _storage.clearAll();
          // Note: Full logout navigation should be handled by BLoC listening to storage changes
          // or a global event bus. For now, we fail the request.
        }
      }
    }
    
    // Rate limit awareness: All 3 auth endpoints are limited to 10 req/min/IP
    if (err.response?.statusCode == 429) {
      // Fail fast and show error
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: 'Rate limit exceeded. Please try again later.',
          response: err.response,
        ),
      );
    }

    super.onError(err, handler);
  }
}
