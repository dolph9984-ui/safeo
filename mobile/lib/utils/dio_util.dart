import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';


class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.106:3000',//telephone
      //baseUrl: 'http://10.0.2.2:3000', //android emulator
      //baseUrl: 'https://safeo.greny.app', //web
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}
/*

const baseUrl = 'https://safeo.greny.app';


class DioClient {
  static final Dio dio = _createDio();
 
  static const String _certificateSHA256 = '724B4AF45AC5955912FD7EEB70662EF2504E66F829C849941B6E14ABB868417E'; 
  static const bool _enableCertificatePinning = true; 

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Certificate Pinning
    if (_enableCertificatePinning) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        return HttpClient()
          ..badCertificateCallback = (X509Certificate cert, String host, int port) {
            final certBytes = cert.der; 
            final digest = sha256.convert(certBytes);
            
            final certFingerprint = digest
                .toString()
                .toUpperCase()
                .replaceAll(':', '');

            final expectedFingerprint = _certificateSHA256
                .toUpperCase()
                .replaceAll(':', '');

            final isValid = certFingerprint == expectedFingerprint;

            if (!isValid) {
              print('CERTIFICATE MISMATCH - POSSIBLE MITM ATTACK');
              print('Expected : $expectedFingerprint');
              print('Received : $certFingerprint');
            } else {
              print('Certificate validated successfully');
            }

            return isValid;
          };
      };
    } else {
      print('Certificate Pinning DÉSACTIVÉ - À UTILISER EN DEV SEULEMENT !');
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // Sanitisation des headers sensibles
          final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
          sanitizedHeaders.remove('Authorization');
          sanitizedHeaders.remove('X-API-Key');
          sanitizedHeaders.remove('Cookie');

          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('Headers (sanitized): $sanitizedHeaders');
          
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
          if (err.response != null) {
            print('Data: ${err.response?.data}');
          }
          return handler.next(err);
        },
      ),
    );

    return dio;
  }
}

*/