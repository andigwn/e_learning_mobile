class Absensi {
  final int idAbsensi;
  final int idSiswaRombel;
  final int idJadwal;
  final DateTime tanggal;
  final String status;
  final int pertemuan;
  final double? latitude;
  final double? longitude;
  final String? alamatIp;
  final String? deviceId;
  final String statusVerifikasi;
  final String verifikasiAbsensi;
  final Map<String, dynamic>? siswaRombel;
  final Map<String, dynamic>? jadwal;

  Absensi({
    required this.idAbsensi,
    required this.idSiswaRombel,
    required this.idJadwal,
    required this.tanggal,
    required this.status,
    required this.pertemuan,
    this.latitude,
    this.longitude,
    this.alamatIp,
    this.deviceId,
    required this.statusVerifikasi,
    required this.verifikasiAbsensi,
    this.siswaRombel,
    this.jadwal,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    // Helper functions for safe parsing
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    DateTime parseDate(dynamic value) {
      try {
        if (value == null) return DateTime.now();
        if (value is DateTime) return value;
        if (value is String) {
          // Handle both date and datetime strings
          if (value.contains('T')) {
            return DateTime.parse(value).toLocal();
          } else {
            return DateTime.parse(value).toLocal();
          }
        }
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    Map<String, dynamic>? parseMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
      return null;
    }

    return Absensi(
      idAbsensi: parseInt(json['id_absensi']),
      idSiswaRombel: parseInt(json['id_siswa_rombel']),
      idJadwal: parseInt(json['id_jadwal']),
      tanggal: parseDate(json['tanggal']),
      status: json['status']?.toString() ?? 'Alpa',
      pertemuan: parseInt(json['pertemuan']),
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      alamatIp: json['alamat_ip']?.toString(),
      deviceId: json['device_id']?.toString(),
      statusVerifikasi:
          json['status_verifikasi']?.toString() ?? 'Terverifikasi',
      verifikasiAbsensi: json['verifikasi_absensi']?.toString() ?? 'TepatWaktu',
      siswaRombel: parseMap(json['siswa_rombel']),
      jadwal: parseMap(json['jadwal']),
    );
  }

  String get ruangan {
    if (jadwal != null &&
        jadwal!['ruangan'] is Map &&
        jadwal!['ruangan']['nama_ruangan'] != null) {
      return jadwal!['ruangan']['nama_ruangan'] as String;
    }
    return '-';
  }
}
