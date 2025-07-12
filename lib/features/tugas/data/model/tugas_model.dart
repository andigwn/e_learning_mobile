import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class Tugas {
  final int? id;
  final String? idJadwal;
  final String? judul;
  final String? deskripsi;
  final String? deadline;
  final String? filePetunjuk;
  final Jadwal? jadwal;

  Tugas({
    this.id,
    this.idJadwal,
    this.judul,
    this.deskripsi,
    this.deadline,
    this.filePetunjuk,
    this.jadwal,
  });

  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      id: json['id_tugas'],
      idJadwal: json['id_jadwal'].toString(),
      judul: json['judul'].toString(),
      deskripsi: json['deskripsi'].toString(),
      deadline: json['deadline'].toString(),
      filePetunjuk: json['file_petunjuk'].toString(),
      jadwal:
          json['jadwal'] != 'jadwal invalid'
              ? Jadwal.fromJson(json['jadwal'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tugas': id,
      'id_jadwal': idJadwal,
      'judul': judul,
      'deskripsi': deskripsi,
      'deadline': deadline,
      'file_petunjuk': filePetunjuk,
      'jadwal': jadwal?.toJson(),
    };
  }
}
