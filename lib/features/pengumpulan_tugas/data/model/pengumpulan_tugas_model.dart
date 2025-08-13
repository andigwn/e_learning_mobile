import 'package:equatable/equatable.dart';

class PengumpulanTugas extends Equatable {
  final int idPengumpulanTugas;
  final int idTugas;
  final int idSiswaRombel; // Diubah dari idSiswa
  final String linkTugas;
  final String status;
  final String tanggalPengumpulan;
  final int nilai;
  final String komentar;
  final TugasDetail? tugas; // Tambahkan detail tugas
  final SiswaRombelDetail? siswaRombel; // Tambahkan detail siswa_rombel

  const PengumpulanTugas({
    required this.idPengumpulanTugas,
    required this.idTugas,
    required this.idSiswaRombel, // Diubah dari idSiswa
    required this.linkTugas,
    this.status = "Dikumpulkan",
    this.tanggalPengumpulan = "",
    this.nilai = 0,
    this.komentar = "",
    this.tugas,
    this.siswaRombel,
  });

  factory PengumpulanTugas.fromJson(Map<String, dynamic> json) {
    return PengumpulanTugas(
      idPengumpulanTugas: json['id_pengumpulan_tugas'] as int? ?? 0,
      idTugas: json['id_tugas'] as int? ?? 0,
      idSiswaRombel:
          json['id_siswa_rombel'] as int? ?? 0, // Diambil dari field baru
      linkTugas: json['link_tugas'] as String? ?? '',
      status: json['status'] as String? ?? 'Dikumpulkan',
      tanggalPengumpulan: json['tanggal_pengumpulan'] as String? ?? '',
      nilai: json['nilai'] as int? ?? 0,
      komentar: json['komentar'] as String? ?? '',
      tugas: json['tugas'] != null ? TugasDetail.fromJson(json['tugas']) : null,
      siswaRombel:
          json['siswa_rombel'] != null
              ? SiswaRombelDetail.fromJson(json['siswa_rombel'])
              : null,
    );
  }

  @override
  List<Object> get props => [
    idPengumpulanTugas,
    idTugas,
    idSiswaRombel,
    linkTugas,
    status,
    tanggalPengumpulan,
    nilai,
    komentar,
  ];
}

// Model untuk nested object "tugas"
class TugasDetail extends Equatable {
  final int idTugas;
  final int idJadwal;
  final String judul;
  final String deskripsi;
  final String filePetunjuk;
  final String deadline;
  final int? idKomponen;

  const TugasDetail({
    required this.idTugas,
    required this.idJadwal,
    required this.judul,
    required this.deskripsi,
    required this.filePetunjuk,
    required this.deadline,
    this.idKomponen,
  });

  factory TugasDetail.fromJson(Map<String, dynamic> json) {
    return TugasDetail(
      idTugas: json['id_tugas'] as int? ?? 0,
      idJadwal: json['id_jadwal'] as int? ?? 0,
      judul: json['judul'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      filePetunjuk: json['file_petunjuk'] as String? ?? '',
      deadline: json['deadline'] as String? ?? '',
      idKomponen: json['id_komponen'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    idTugas,
    idJadwal,
    judul,
    deskripsi,
    filePetunjuk,
    deadline,
    idKomponen,
  ];
}

// Model untuk nested object "siswa_rombel"
class SiswaRombelDetail extends Equatable {
  final int id;
  final int idRombel;
  final int idSiswa;
  final int idPeriode;

  const SiswaRombelDetail({
    required this.id,
    required this.idRombel,
    required this.idSiswa,
    required this.idPeriode,
  });

  factory SiswaRombelDetail.fromJson(Map<String, dynamic> json) {
    return SiswaRombelDetail(
      id: json['id'] as int? ?? 0,
      idRombel: json['id_rombel'] as int? ?? 0,
      idSiswa: json['id_siswa'] as int? ?? 0,
      idPeriode: json['id_periode'] as int? ?? 0,
    );
  }

  @override
  List<Object> get props => [id, idRombel, idSiswa, idPeriode];
}
