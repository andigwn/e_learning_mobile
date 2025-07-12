import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/data/model/pengumpulan_tugas_model.dart';

class PengumpulanTugasRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<PengumpulanTugas>> getPengumpulanTugasBySiswa(
    int siswaId,
    int tugasId,
  ) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.pengumpulanTugasEndpoint(siswaId, tugasId)}/search',
      );
      final data = response.data['data'] as List;
      return data.map((e) => PengumpulanTugas.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ?? 'Gagal memuat data tugas',
      );
    }
  }

  Future<PengumpulanTugas> submitTugas({
    required int siswaId,
    required int tugasId,
    required String linkTugas,
    required String tanggalPengumpulan,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.pengumpulanTugasEndpoint(siswaId, tugasId)}/create',
        data: {
          'id_siswa': siswaId,
          'id_tugas': tugasId,
          'link_tugas': linkTugas,
          'tanggal_pengumpulan': tanggalPengumpulan,
        },
      );
      return PengumpulanTugas.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ?? 'Gagal mengumpulkan tugas',
      );
    }
  }
}
