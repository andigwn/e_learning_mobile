import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class JadwalRepo {
  Future<List<Jadwal>> getJadwal() async {
    try {
      // Pastikan token tersedia
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }
      final response = await ApiClient.dio.get(
        ApiConstants.jadwalEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await SecureStorage.getToken()}',
          },
        ),
      );
      if (response.data['data'] == null || response.data['data'].isEmpty) {
        throw Exception('Data jadwal tidak ditemukan');
      }
      return (response.data['data'] as List)
          .map((jadwalJson) => Jadwal.fromJson(jadwalJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ?? 'Gagal memuat daftar siswa',
      );
    }
  }
}
