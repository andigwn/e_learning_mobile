import 'package:flutter/material.dart'; // For TimeOfDay

// Add these enum and class definitions at the top of the file
enum Hari { senin, selasa, rabu, kamis, jumat, sabtu, minggu }

enum JenisJadwal { teori, praktikum }

class GuruMapel {
  final int id;
  final Map<String, dynamic> guru;
  final Map<String, dynamic> mapel;

  GuruMapel({required this.id, required this.guru, required this.mapel});

  factory GuruMapel.fromJson(Map<String, dynamic> json) {
    return GuruMapel(
      id: json['id'] as int? ?? 0,
      guru: json['guru'] is Map ? Map<String, dynamic>.from(json['guru']) : {},
      mapel:
          json['mapel'] is Map ? Map<String, dynamic>.from(json['mapel']) : {},
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'guru': guru, 'mapel': mapel};
}

class Rombel {
  final int id;
  final String nama;
  final int jumlahSiswa;
  final String kodeJurusan;
  final int idRuangan;

  Rombel({
    required this.id,
    required this.nama,
    required this.jumlahSiswa,
    required this.kodeJurusan,
    required this.idRuangan,
  });

  factory Rombel.fromJson(Map<String, dynamic> json) {
    return Rombel(
      id: json['id_rombel'] as int? ?? 0,
      nama: json['nama_rombel'] as String? ?? '',
      jumlahSiswa: json['jumlah_siswa'] as int? ?? 0,
      kodeJurusan: json['kode_jurusan'] as String? ?? '',
      idRuangan: json['id_ruangan'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_rombel': id,
    'nama_rombel': nama,
    'jumlah_siswa': jumlahSiswa,
    'kode_jurusan': kodeJurusan,
    'id_ruangan': idRuangan,
  };
}

class Periode {
  final int id;
  final String jenis;
  final String nama;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String semester;
  final String tahunAjaran;
  final bool isActive;

  Periode({
    required this.id,
    required this.jenis,
    required this.nama,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.semester,
    required this.tahunAjaran,
    required this.isActive,
  });

  factory Periode.fromJson(Map<String, dynamic> json) {
    return Periode(
      id: json['id_periode'] as int? ?? 0,
      jenis: json['jenis_periode'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalSelesai: DateTime.parse(json['tanggal_selesai']),
      semester: json['semester'] as String? ?? '',
      tahunAjaran: json['tahun_ajaran'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_periode': id,
    'jenis_periode': jenis,
    'nama': nama,
    'tanggal_mulai': tanggalMulai.toIso8601String(),
    'tanggal_selesai': tanggalSelesai.toIso8601String(),
    'semester': semester,
    'tahun_ajaran': tahunAjaran,
    'is_active': isActive,
  };
}

class Ruangan {
  final int id;
  final String nama;
  final String status;

  Ruangan({required this.id, required this.nama, required this.status});

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'] as int? ?? 0,
      nama: json['nama_ruangan'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama_ruangan': nama,
    'status': status,
  };
}

class Jadwal {
  final int id;
  final Hari hari;
  final TimeOfDay jamMulai;
  final TimeOfDay jamSelesai;
  final DateTime tanggal;
  final JenisJadwal jenis;
  final int pertemuanKe;
  final GuruMapel guruMapel;
  final Rombel rombel;
  final Periode periode;
  final Ruangan ruangan;

  Jadwal({
    required this.id,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tanggal,
    required this.jenis,
    required this.pertemuanKe,
    required this.guruMapel,
    required this.rombel,
    required this.periode,
    required this.ruangan,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      id: json['id_jadwal'] as int? ?? 0,
      hari: Hari.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['hari'] as String?)?.toLowerCase(),
        orElse: () => Hari.senin,
      ),
      jamMulai: _parseTime(json['jam_mulai'] as String?),
      jamSelesai: _parseTime(json['jam_selesai'] as String?),
      tanggal: DateTime.parse(json['tanggal'] as String),
      jenis: JenisJadwal.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == (json['jenis'] as String?)?.toLowerCase(),
        orElse: () => JenisJadwal.teori,
      ),
      pertemuanKe: json['pertemuan_ke'] as int? ?? 0,
      guruMapel: GuruMapel.fromJson(json['guru_mapel'] as Map<String, dynamic>),
      rombel: Rombel.fromJson(json['rombel'] as Map<String, dynamic>),
      periode: Periode.fromJson(json['periode'] as Map<String, dynamic>),
      ruangan: Ruangan.fromJson(json['ruangan'] as Map<String, dynamic>),
    );
  }

  static TimeOfDay _parseTime(String? time) {
    if (time == null) return const TimeOfDay(hour: 0, minute: 0);
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Duration get durasi {
    final mulai = jamMulai;
    final selesai = jamSelesai;
    final mulaiMinutes = mulai.hour * 60 + mulai.minute;
    final selesaiMinutes = selesai.hour * 60 + selesai.minute;
    return Duration(minutes: selesaiMinutes - mulaiMinutes);
  }

  Map<String, dynamic> toJson() => {
    'id_jadwal': id,
    'hari': hari.name,
    'jam_mulai':
        '${jamMulai.hour}:${jamMulai.minute.toString().padLeft(2, '0')}',
    'jam_selesai':
        '${jamSelesai.hour}:${jamSelesai.minute.toString().padLeft(2, '0')}',
    'tanggal': tanggal.toIso8601String(),
    'jenis': jenis.name,
    'pertemuan_ke': pertemuanKe,
    'guru_mapel': guruMapel.toJson(),
    'rombel': rombel.toJson(),
    'periode': periode.toJson(),
    'ruangan': ruangan.toJson(),
  };
  String get formattedJam {
    final mulai =
        '${jamMulai.hour}:${jamMulai.minute.toString().padLeft(2, '0')}';
    final selesai =
        '${jamSelesai.hour}:${jamSelesai.minute.toString().padLeft(2, '0')}';
    return '$mulai - $selesai';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Jadwal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
