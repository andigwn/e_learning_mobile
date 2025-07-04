class Absensi {
  final int? idAbsensi;
  final int? idSiswa;
  final int? idJadwal;
  final String? tanggal;
  final int? pertemuan;
  final String? status;
  final double? latitude;
  final double? longitude;
  final String? alamatIp;
  final String? deviceId;
  final String? statusVerifikasi;
  final String? verifikasiAbsensi;

  Absensi({
    this.idAbsensi,
    this.idSiswa,
    this.idJadwal,
    this.tanggal,
    this.pertemuan,
    this.status,
    this.latitude,
    this.longitude,
    this.alamatIp,
    this.deviceId,
    this.statusVerifikasi,
    this.verifikasiAbsensi,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) => Absensi(
    idAbsensi: json['id_absensi'] ?? 0,
    idSiswa: json['id_siswa'] ?? 0,
    idJadwal: json['id_jadwal'] ?? 0,
    tanggal: json['tanggal'] ?? '',
    pertemuan: json['pertemuan'] ?? 0,
    status: json['status'] ?? '',
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    alamatIp: json['alamat_ip'] ?? '',
    deviceId: json['device_id'] ?? '',
    statusVerifikasi: json['status_verifikasi'] ?? '',
    verifikasiAbsensi: json['verifikasi_absensi'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id_absensi': idAbsensi,
    'id_siswa': idSiswa,
    'id_jadwal': idJadwal,
    'tanggal': tanggal,
    'pertemuan': pertemuan,
    'status': status,
    'latitude': latitude,
    'longitude': longitude,
    'alamat_ip': alamatIp,
    'device_id': deviceId,
    'status_verifikasi': statusVerifikasi,
    'verifikasi_absensi': verifikasiAbsensi,
  };
}
