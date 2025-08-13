import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/data/model/pengumpulan_tugas_model.dart';

class PengumpulanTugasRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<PengumpulanTugas>> getRiwayatPengumpulanTugasSiswa({
    required int siswaRombelId,
    int? tugasId,
    String? tanggalPengumpulan,
    String? status,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.baseUrl +
            ApiConstants.riwayatPengumpulanTugasSiswa(
              siswaRombelId: siswaRombelId,
              tugasId: tugasId,
              tanggalPengumpulan: tanggalPengumpulan,
              status: status,
              page: page,
              size: size,
            ),
      );

      return (response.data['data'] as List)
          .map((item) => PengumpulanTugas.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ??
            'Gagal memuat riwayat pengumpulan tugas',
      );
    }
  }

  Future<PengumpulanTugas> submitTugas({
    required int tugasId,
    required String linkTugas,
    required String tanggalPengumpulan,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.pengumpulanTugasEndpoint(tugasId),
        data: {
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

  // Future<PengumpulanTugas?> getPengumpulanSiswa(
  //   int tugasId,
  //   int siswaRombelId,
  // ) async {
  //   try {
  //     final response = await _dio.get(
  //       ApiConstants.pengumpulanTugasByRombelEndpoint(tugasId, siswaRombelId),
  //       queryParameters: {'id_siswa_rombel': siswaRombelId},
  //     );

  //     if (response.data['data'] != null && response.data['data'].isNotEmpty) {
  //       return PengumpulanTugas.fromJson(response.data['data'][0]);
  //     }
  //     return null;
  //   } on DioException catch (e) {
  //     throw Exception(
  //       e.response?.data['message']?.toString() ??
  //           'Gagal memuat data pengumpulan',
  //     );
  //   }
  // }

  Future<PengumpulanTugas> updatePengumpulanSiswa({
    required int idPengumpulan,
    required String linkTugas,
    required String tanggalPengumpulan,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}pengumpulan-tugas/$idPengumpulan',
        data: {
          'link_tugas': linkTugas,
          'tanggal_pengumpulan': tanggalPengumpulan,
        },
      );
      return PengumpulanTugas.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message']?.toString() ??
            'Gagal mengupdate pengumpulan tugas',
      );
    }
  }
}
