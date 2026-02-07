import 'package:dio/dio.dart';
import 'package:securite_mobile/model/auth/session_token.dart';
import 'package:securite_mobile/services/auth/session_service.dart';

class AuthInterceptor extends Interceptor {
  final SessionService sessionService;
  final Dio dio;

  bool _isRefreshing = false;

  AuthInterceptor(this.sessionService, this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains('/auth/')) {
      final accessToken = await sessionService.getAccessToken();

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
        final refreshToken = await sessionService.getRefreshToken();

        if (refreshToken == null || refreshToken.isEmpty) {
          await SessionService().endSession();
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
          await sessionService.endSession();
          _isRefreshing = false;
          return handler.next(err);
        }

        await SessionTokenModel.storeAccessToken(newAccessToken);

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
        await sessionService.endSession();
      }
    }

    handler.next(err);
  }
}
