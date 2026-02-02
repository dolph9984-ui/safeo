import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';

/// Module 1, page 54
class DioClient {
  static final Dio dio = _createDio();
 
  static const String _certificateSHA256 = '724B4AF45AC5955912FD7EEB70662EF2504E66F829C849941B6E14ABB868417E'; 
  static const bool _enableCertificatePinning = true; 

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://safeo.greny.app',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (_enableCertificatePinning) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        // Crée un client avec le callback de validation
        return HttpClient()
          ..badCertificateCallback = (X509Certificate cert, String host, int port) {
            final certBytes = cert.der; 
            final digest = sha256.convert(certBytes);
            
            // Formatage identique pour comparaison
            final certFingerprint = digest
                .toString()
                .toUpperCase()
                .replaceAll(':', '');

            final expectedFingerprint = _certificateSHA256
                .toUpperCase()
                .replaceAll(':', '');

            final isValid = certFingerprint == expectedFingerprint;

            if (!isValid) {
              print('⚠️ CERTIFICATE MISMATCH - POSSIBLE MITM ATTACK');
              print('Expected : $expectedFingerprint');
              print('Received : $certFingerprint');
            } else {
              print('✅ Certificate validated successfully');
            }

            return isValid;
          };
      };
    } else {
      print('⚠️ Certificate Pinning DÉSACTIVÉ - À UTILISER EN DEV SEULEMENT !');
    }

    dio.interceptors.add(SecureLoggingInterceptor());

    return dio;
  }
}

class SecureLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
    sanitizedHeaders.remove('Authorization');
    sanitizedHeaders.remove('X-API-Key');
    sanitizedHeaders.remove('Cookie');

    print('REQUEST: ${options.method} ${options.path}');
    print('Headers (sanitized): $sanitizedHeaders');

    // Pour voir le body (attention en prod !)
    // if (options.data != null) {
    //   print('Body: ${options.data}');
    // }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode} ${response.realUri.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    if (err.response != null) {
      print('   Status: ${err.response?.statusCode}');
      print('   Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}