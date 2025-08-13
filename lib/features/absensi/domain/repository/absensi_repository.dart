import 'package:dio/dio.dart';
import 'package:e_learning_mobile/core/api/api_client.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/absensi/data/model/absensi_model.dart';

class AbsensiException implements Exception {
  final String message;
  AbsensiException(this.message);

  @override
  String toString() => message;
}

class AbsensiRepository {
  final Dio _dio = ApiClient.dio;
  Map<String, dynamic>? _schoolLocationCache;
  DateTime? _lastLocationFetchTime;

  Future<String> _getAuthToken() async {
    final token = await SecureStorage.getToken();
    if (token == null || token.isEmpty) {
      throw AbsensiException('Token tidak tersedia');
    }
    return token;
  }

  Future<List<Absensi>> getAbsensiBySiswaJadwal({
    required int siswaRombelId,
    required int jadwalId,
  }) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.get(
        '${ApiConstants.absensiEndpoint(siswaRombelId, jadwalId)}/rekap',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Validasi struktur response
      if (response.statusCode == 401) {
        throw AbsensiException('Sesi berakhir, silakan login kembali');
      }

      if (response.data is! Map<String, dynamic> ||
          response.data['data'] is! List) {
        throw FormatException('Invalid response structure');
      }

      return (response.data['data'] as List)
          .map((json) => Absensi.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMsg = e.response?.data?['message'] ?? 'Terjadi kesalahan';

      switch (statusCode) {
        case 400:
          throw AbsensiException(errorMsg);
        case 401:
          throw AbsensiException('Sesi berakhir, silakan login kembali');
        case 404:
          throw AbsensiException('Data tidak ditemukan');
        default:
          throw AbsensiException('Error $statusCode: $errorMsg');
      }
    } catch (e) {
      throw AbsensiException('Terjadi kesalahan: $e');
    }
  }

  Future<Absensi> absenMasuk({
    required int siswaRombelId,
    required int jadwalId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Validasi koordinat sebelum kirim ke backend
      if (latitude == 0.0 || longitude == 0.0) {
        throw AbsensiException('Lokasi tidak valid');
      }

      final token = await _getAuthToken();

      final response = await _dio.post(
        '${ApiConstants.absensiEndpoint(siswaRombelId, jadwalId)}/masuk',
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().toIso8601String(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Handle error khusus lokasi
      if (response.statusCode == 400) {
        final errorMsg = response.data?['message'] ?? '';
        if (errorMsg.contains('luar area')) {
          throw AbsensiException('Lokasi di luar area sekolah');
        }
      }

      // Validasi struktur response
      if (response.data is! Map<String, dynamic> ||
          response.data['data'] is! Map<String, dynamic>) {
        throw FormatException('Invalid response structure');
      }

      return Absensi.fromJson(response.data['data']);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMsg = e.response?.data?['message'] ?? 'Terjadi kesalahan';

      switch (statusCode) {
        case 400:
          throw AbsensiException(errorMsg);
        case 401:
          throw AbsensiException('Sesi berakhir, silakan login kembali');
        case 404:
          throw AbsensiException('Data tidak ditemukan');
        default:
          throw AbsensiException('Error $statusCode: $errorMsg');
      }
    } catch (e) {
      throw AbsensiException('Terjadi kesalahan: $e');
    }
  }

  Future<Absensi> absenMasukWithRetry({
    required int siswaRombelId,
    required int jadwalId,
    required double latitude,
    required double longitude,
    int maxRetries = 2,
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await absenMasuk(
          siswaRombelId: siswaRombelId,
          jadwalId: jadwalId,
          latitude: latitude,
          longitude: longitude,
        );
      } on AbsensiException catch (e) {
        // Hanya retry untuk error jaringan/timeout
        if (!e.message.contains('timeout') || i == maxRetries - 1) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw AbsensiException('Gagal setelah $maxRetries percobaan');
  }

  Future<Map<String, dynamic>> getSchoolLocation() async {
    try {
      // Gunakan cache jika tersedia dan belum kadaluarsa (1 jam)
      if (_schoolLocationCache != null &&
          _lastLocationFetchTime != null &&
          DateTime.now().difference(_lastLocationFetchTime!) <
              const Duration(hours: 1)) {
        return _schoolLocationCache!;
      }

      final token = await _getAuthToken();
      final response = await _dio.get(
        ApiConstants.schoolLocationEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 401) {
        throw AbsensiException('Sesi berakhir, silakan login kembali');
      }

      // Validasi response
      if (response.data is! Map<String, dynamic> ||
          response.data['data'] == null) {
        throw FormatException('Invalid school location response');
      }

      // Update cache
      _schoolLocationCache = {
        'latitude': response.data['data']['latitude_pusat']?.toDouble() ?? 0.0,
        'longitude':
            response.data['data']['longitude_pusat']?.toDouble() ?? 0.0,
        'radius': response.data['data']['radius_meter']?.toDouble() ?? 0.0,
      };
      _lastLocationFetchTime = DateTime.now();

      return _schoolLocationCache!;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMsg =
          e.response?.data?['message'] ?? 'Gagal mendapatkan lokasi sekolah';

      switch (statusCode) {
        case 400:
          throw AbsensiException(errorMsg);
        case 401:
          throw AbsensiException('Sesi berakhir, silakan login kembali');
        case 404:
          throw AbsensiException('Lokasi sekolah belum dikonfigurasi');
        default:
          throw AbsensiException('Error $statusCode: $errorMsg');
      }
    } catch (e) {
      throw AbsensiException('Terjadi kesalahan: $e');
    }
  }

  Future<bool> validateAbsenTime(int jadwalId) async {
    try {
      final token = await _getAuthToken();
      final response = await _dio.get(
        '${ApiConstants.jadwalEndpoint}/$jadwalId/waktu-absen',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data?['data']?['is_valid'] ?? false;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMsg =
          e.response?.data?['message'] ?? 'Gagal validasi waktu absen';

      switch (statusCode) {
        case 400:
          throw AbsensiException(errorMsg);
        case 401:
          throw AbsensiException('Sesi berakhir, silakan login kembali');
        case 404:
          throw AbsensiException('Jadwal tidak ditemukan');
        default:
          throw AbsensiException('Error $statusCode: $errorMsg');
      }
    } catch (e) {
      throw AbsensiException('Terjadi kesalahan: $e');
    }
  }
}
