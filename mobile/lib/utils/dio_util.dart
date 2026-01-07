import 'package:dio/dio.dart';

const baseUrl = 'https://safeo-api.onrender.com';

final dio =
    Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
                print('REQUEST[${options.method}] => PATH: ${options.path}');
                return handler.next(options);
              },

          onResponse: (Response response, ResponseInterceptorHandler handler) {
            print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
            return handler.next(response);
          },

          onError: (DioException err, ErrorInterceptorHandler handler) async {
            print(
              'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
            );
            return handler.next(err);
          },
        ),
      );
