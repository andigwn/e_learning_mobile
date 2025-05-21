import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';

class ApiClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
          ),
        )
        ..interceptors.add(LogInterceptor())
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await SecureStorage.getToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
            onError: (error, handler) async {
              if (error.response?.statusCode == 401) {
                await SecureStorage.clearAuthData();
                // Redirect ke login page
              }
              return handler.next(error);
            },
          ),
        );
}
