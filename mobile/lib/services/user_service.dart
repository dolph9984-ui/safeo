import 'package:dio/dio.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class UserService {
  final Dio _dio;

  UserService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<User> getCurrentUser() async {
    final response = await _dio.get('/v1/api/user/me');
    print('response : $response');

    return User.fromJson(response.data);
  }

  Future<List<User>> getAllUsers() async {
    final response = await _dio.get('/v1/api/users');

    final users = (response.data as List)
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();

    return users;
  }
}
