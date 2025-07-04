import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/absensi/data/model/absensi_model.dart';

class AbsensiRepository {
  Future<List<Absensi>> fetchAbsensiSiswa(int siswaId, int jadwalId) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }
      final response = await ApiClient.dio.get(
        '${ApiConstants.absensiEndpoint(siswaId, jadwalId)}/rekap',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'];
      if (data == null || data is! List || data.isEmpty) {
        return [];
      }
      return data
          .where(
            (absensiJson) =>
                absensiJson != null && absensiJson is Map<String, dynamic>,
          )
          .map<Absensi>((absensiJson) => Absensi.fromJson(absensiJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ?? 'Gagal memuat data absensi',
      );
    }
  }

  Future<void> absenMasuk({
    required int siswaId,
    required int jadwalId,
    required String tanggal,
    required String status,
    required double latitude,
    required double longitude,
    required String alamatIp,
    required String deviceId,
    required String statusVerifikasi,
    required String verifikasiAbsensi,
  }) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }
      final response = await ApiClient.dio.post(
        '${ApiConstants.absensiEndpoint(siswaId, jadwalId)}/masuk',
        data: {
          'tanggal': tanggal,
          'status': status,
          'latitude': latitude,
          'longitude': longitude,
          'alamat_ip': alamatIp,
          'device_id': deviceId,
          'status_verifikasi': statusVerifikasi,
          'verifikasi_absensi': verifikasiAbsensi,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['message'] == null) {
        throw Exception('Gagal melakukan absensi');
      }
    } on DioException catch (e) {
      String msg =
          e.response?.data['message']?.toString() ?? 'Gagal melakukan absensi';
      msg = msg.replaceAll(RegExp(r'Exception:?\s*'), '').trim();
      // Hanya lempar pesan inti tanpa Exception:
      throw msg;
    }
  }
}
