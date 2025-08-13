import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class JadwalRepo {
  Future<List<Jadwal>> getJadwal(int rombelId) async {
    try {
      // Pastikan token tersedia
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }
      final response = await ApiClient.dio.get(
        ApiConstants.jadwalEndpoint(rombelId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'];
      if (data == null || data is! List || data.isEmpty) {
        // Return list kosong agar UI tetap jalan, tidak lempar error
        return [];
      }

      return data
          .where(
            (jadwalJson) =>
                jadwalJson != null && jadwalJson is Map<String, dynamic>,
          )
          .map<Jadwal>((jadwalJson) => Jadwal.fromJson(jadwalJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ?? 'Gagal memuat daftar siswa',
      );
    }
  }
}
