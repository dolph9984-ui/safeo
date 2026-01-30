import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      //baseUrl: 'http://192.168.100.106:3000',//telephone
      //baseUrl: 'http://10.0.2.2:3000', //android emulator
      baseUrl: 'https://safeo.greny.app', //web
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}