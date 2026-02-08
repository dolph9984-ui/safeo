import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:securite_mobile/utils/auth_interceptor.dart';

class DioClient {
  static late final Dio dio;

  static const String baseUrl = 'https://safeo-api.greny.app/';

  // certificat serveur
  static const String certificateSHA256 =
      '25161E8BD97A385E80866021CF2AA1712DD8C70B8C4C9E9202AE73208A3DB957';

  static void initialize() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      return HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) {
              final fingerprint = sha256
                  .convert(cert.der)
                  .toString()
                  .toUpperCase();
              return fingerprint == certificateSHA256;
            };
    };

    dio.interceptors.add(AuthInterceptor(dio));
  }
}
