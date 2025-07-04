import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/tugas/data/model/tugas_model.dart';

class TugasRepo {
  Future<List<Tugas>> getTugas(int jadwalId) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }
      final response = await ApiClient.dio.get(
        ApiConstants.tugasEndpoint(jadwalId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'];
      if (data == null || data is! List || data.isEmpty) {
        // Return list kosong agar UI tetap jalan, tidak lempar error
        return [];
      }
      return data.map((e) => Tugas.fromJson(e)).toList();
    } on DioException catch (e) {
      // Tangani error dari DioException
      if (e.response?.data != null && e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message'].toString());
      }
      throw Exception('Gagal memuat daftar tugas: ${e.message}');
    }
  }
}
