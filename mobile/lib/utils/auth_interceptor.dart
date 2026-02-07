import 'package:dio/dio.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService storage;
  final Dio dio;

  bool _isRefreshing = false;

  AuthInterceptor(this.storage, this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains('/auth/')) {
      final accessToken = await storage.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si token expiré
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await storage.getRefreshToken();

        if (refreshToken == null || refreshToken.isEmpty) {
          await storage.logout();
          _isRefreshing = false;
          return handler.next(err);
        }

        // Refresh du token
        final response = await dio.post(
          '/v1/api/auth/refresh-access-token',
          data: {'refreshToken': refreshToken},
          options: Options(headers: {'Authorization': null}),
        );

        final newAccessToken = response.data['accessToken'];

        if (newAccessToken == null) {
          await storage.logout();
          _isRefreshing = false;
          return handler.next(err);
        }

        await storage.saveAccessToken(newAccessToken);

        final retryResponse = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: {
              ...err.requestOptions.headers,
              'Authorization': 'Bearer $newAccessToken',
            },
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (_) {
        _isRefreshing = false;
        await storage.logout();
      }
    }

    handler.next(err);
  }
}
