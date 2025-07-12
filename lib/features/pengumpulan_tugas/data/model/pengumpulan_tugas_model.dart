import 'package:equatable/equatable.dart';

class PengumpulanTugas extends Equatable {
  final int idPengumpulanTugas;
  final int idTugas;
  final int idSiswa;
  final String linkTugas;
  final String status;
  final String tanggalPengumpulan;
  final int nilai;
  final String komentar;

  const PengumpulanTugas({
    required this.idPengumpulanTugas,
    required this.idTugas,
    required this.idSiswa,
    required this.linkTugas,
    this.status = "Dikumpulkan",
    this.tanggalPengumpulan = "",
    this.nilai = 0,
    this.komentar = "",
  });

  factory PengumpulanTugas.fromJson(Map<String, dynamic> json) {
    return PengumpulanTugas(
      idPengumpulanTugas: json['id_pengumpulan_tugas'] as int? ?? 0,
      idTugas: json['id_tugas'] as int? ?? 0,
      idSiswa: json['id_siswa'] as int? ?? 0,
      linkTugas: json['link_tugas'] as String? ?? '',
      status: json['status'] as String? ?? 'Dikumpulkan',
      tanggalPengumpulan: json['tanggal_pengumpulan'] as String? ?? '',
      nilai: json['nilai'] as int? ?? 0,
      komentar: json['komentar'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [
    idPengumpulanTugas,
    idTugas,
    idSiswa,
    linkTugas,
    status,
    tanggalPengumpulan,
    nilai,
    komentar,
  ];
}
