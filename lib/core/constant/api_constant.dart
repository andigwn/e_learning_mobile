class ApiConstants {
  static const String baseUrl = 'http://10.10.10.153:3002/api/';
  static const String fileUrl = 'http://10.10.10.153:3002/uploads/';
  static const String loginEndpoint = 'users/login';
  static const String siswaEndpoint = 'siswa/current';
  static String jadwalEndpoint(int rombelId) => 'rombel/$rombelId/jadwal';
  static String absensiEndpoint(int siswaId, int jadwalId) =>
      'siswa/$siswaId/jadwal/$jadwalId/absensi';
  static String tugasEndpoint(int jadwalId) => 'jadwal/$jadwalId/tugas';
}
