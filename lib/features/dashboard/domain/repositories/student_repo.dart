import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';

class StudentRepository {
  Future<Student> getStudentProfile() async {
    try {
      // Pastikan token tersedia
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }

      final response = await ApiClient.dio.get(
        ApiConstants.siswaEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['data'] == null || response.data['data'].isEmpty) {
        throw Exception('Data siswa tidak ditemukan');
      }

      return Student.fromJson(response.data['data'][0]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ??
            'Gagal memuat profil siswa. Silakan coba lagi.',
      );
    }
  }

  Future<List<Student>> getAllStudents() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Sesi telah berakhir. Silakan login kembali');
      }

      final response = await ApiClient.dio.get(
        '${ApiConstants.siswaEndpoint}/all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return (response.data['data'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ?? 'Gagal memuat daftar siswa',
      );
    }
  }
}
