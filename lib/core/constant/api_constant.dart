class ApiConstants {
  static const String baseUrl = 'http://192.168.1.8:3002/api/';
  static const String fileUrl = 'http://192.168.1.8:3002/uploads/';
  static const String loginEndpoint = 'users/login';
  static const String siswaEndpoint = 'siswa/current';
  static String jadwalEndpoint(int rombelId) => 'rombel/$rombelId/jadwal';
  static String absensiEndpoint(int siswaId, int jadwalId) =>
      'siswa/$siswaId/jadwal/$jadwalId/absensi';
  static String tugasEndpoint(int jadwalId) => 'jadwal/$jadwalId/tugas';
  static String pengumpulanTugasEndpoint(int siswaId, int tugasId) =>
      'siswa/$siswaId/tugas/$tugasId/pengumpulan-tugas';
  static String pengumpulanTugasByRombelEndpoint(int rombelId, int tugasId) =>
      'rombel/$rombelId/tugas/$tugasId/pengumpulan-tugas';
}
