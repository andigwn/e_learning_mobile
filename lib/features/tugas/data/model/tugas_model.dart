import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class Tugas {
  final int? id;
  final int? idJadwal;
  final String? judul;
  final String? deskripsi;
  final String? deadline;
  final String? filePetunjuk;
  final Jadwal? jadwal;
  final int? idKomponen; // Tambahkan field baru

  Tugas({
    this.id,
    this.idJadwal,
    this.judul,
    this.deskripsi,
    this.deadline,
    this.filePetunjuk,
    this.jadwal,
    this.idKomponen, // Tambahkan di constructor
  });

  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      id: _parseInt(json['id_tugas']),
      idJadwal: _parseInt(json['id_jadwal']),
      judul: _safeParseString(json['judul']),
      deskripsi: _safeParseString(json['deskripsi']),
      deadline: _safeParseString(json['deadline']),
      filePetunjuk: _safeParseString(json['file_petunjuk']),
      idKomponen: _parseInt(json['id_komponen']), // Parse field baru
      jadwal: _parseJadwal(json['jadwal']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _safeParseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static Jadwal? _parseJadwal(dynamic value) {
    if (value == null) return null;
    if (value is String && value.toLowerCase().contains('invalid')) return null;
    if (value is Map<String, dynamic>) {
      try {
        return Jadwal.fromJson(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
