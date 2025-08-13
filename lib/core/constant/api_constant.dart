class ApiConstants {
  static const String baseUrl = 'http://10.102.217.138:3002/api/';
  static const String fileUrl = 'http://10.102.217.138:3002/uploads/';
  static const String loginEndpoint = 'users/login';
  static const String siswaEndpoint = 'siswa/current';
  static const String siswaRombelEndpoint = 'siswa-rombel/current';
  static String jadwalEndpoint(int rombelId) => 'jadwal/rombel/$rombelId/';
  static String absensiEndpoint(int siswaRombelId, int jadwalId) =>
      'siswa/$siswaRombelId/jadwal/$jadwalId/absensi';
  static String tugasEndpoint(int jadwalId) => 'jadwal/$jadwalId/tugas';
  static String pengumpulanTugasEndpoint(int tugasId) =>
      'tugas/$tugasId/pengumpulan-tugas/create';
  static String pengumpulanTugasByRombelEndpoint(int rombelId, int tugasId) =>
      'rombel/$rombelId/tugas/$tugasId/pengumpulan-tugas';
  static const String schoolLocationEndpoint = 'lokasi';
  static String riwayatPengumpulanTugasSiswa({
    int? siswaRombelId,
    int? tugasId,
    String? tanggalPengumpulan,
    String? status,
    int page = 1,
    int size = 10,
  }) {
    final params = {
      if (siswaRombelId != null) 'id_siswa_rombel': siswaRombelId.toString(),
      if (tugasId != null) 'id_tugas': tugasId.toString(),
      if (tanggalPengumpulan != null) 'tanggal_pengumpulan': tanggalPengumpulan,
      if (status != null) 'status': status,
      'page': page.toString(),
      'size': size.toString(),
    };

    return 'pengumpulan-tugas/search?${Uri(queryParameters: params).query}';
  }
}
