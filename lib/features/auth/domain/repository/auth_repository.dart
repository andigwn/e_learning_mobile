import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/features/auth/data/models/login_request.dart';
import 'package:e_learning_mobile/features/auth/data/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String username, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<LoginResponse> login(String username, String password) async {
    try {
      final request = LoginRequest(username: username, password: password);
      final response = await ApiClient.dio.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );
      if (response.data['data']?['token'] == null) {
        throw Exception('Token tidak ditemukan di response');
      }
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login gagal');
    }
  }
}
