class LokasiModel {
  final int id;
  final String namaLokasi;
  final double latitudePusat;
  final double longitudePusat;
  final int radiusMeter;

  LokasiModel({
    required this.id,
    required this.namaLokasi,
    required this.latitudePusat,
    required this.longitudePusat,
    required this.radiusMeter,
  });
  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      id: json['id_lokasi'] as int,
      namaLokasi: json['nama_lokasi'] as String,
      latitudePusat: (json['latitude_pusat'] as num).toDouble(),
      longitudePusat: (json['longitude_pusat'] as num).toDouble(),
      radiusMeter: json['radius_meter'] as int,
    );
  }
}
