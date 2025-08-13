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
        throw Exception('Authentication required');
      }

      final response = await ApiClient.dio.get(
        ApiConstants.tugasEndpoint(jadwalId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Validasi struktur response dasar
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid server response structure');
      }

      final responseData = response.data as Map<String, dynamic>;

      // Validasi keberadaan data dan tipe data
      if (!responseData.containsKey('data') || responseData['data'] == null) {
        return [];
      }

      final data = responseData['data'];

      // Handle jika data bukan list
      if (data is! List) {
        return [];
      }

      // Parse dan kembalikan data dengan error handling per item
      final List<Tugas> tugasList = [];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          final tugas = Tugas.fromJson(item);
          tugasList.add(tugas);
        }
      }

      return tugasList;
    } on DioException catch (e) {
      String errorMessage = 'Failed to load tugas';

      if (e.response != null) {
        // Handle berbagai format error response
        if (e.response!.data is Map) {
          errorMessage =
              e.response!.data['message']?.toString() ??
              e.response!.data['error']?.toString() ??
              errorMessage;
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to load tugas. Please try again later');
    }
  }
}
