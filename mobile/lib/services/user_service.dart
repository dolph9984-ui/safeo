import 'package:dio/dio.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class UserServiceResponse {
  final List<User>? data;
  final int statusCode;

  UserServiceResponse({required this.data, required this.statusCode});
}

class UserService {
  final Dio _dio;

  UserService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<UserServiceResponse> getMe() async {
    try {
      final response = await _dio.get('/v1/api/user/me');
      final userMap = response.data['user'] as Map<String, dynamic>;
      return UserServiceResponse(
        data: [User.fromJson(userMap)],
        statusCode: response.statusCode ?? 200,
      );
    } on DioException catch (e) {
      return UserServiceResponse(
        data: null,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<UserServiceResponse> getAllUsers() async {
    try {
      final response = await _dio.get('/v1/api/users');

      final users = (response.data as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();

      return UserServiceResponse(
        data: users,
        statusCode: response.statusCode ?? 200,
      );
    } on DioException catch (e) {
      return UserServiceResponse(
        data: null,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
