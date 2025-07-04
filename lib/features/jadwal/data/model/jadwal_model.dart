class Jadwal {
  final int? id;
  final String? mapel;
  final String? guru;
  final String? rombel;
  final String? hari;
  final String? jamMulai;
  final String? jamSelesai;
  final String? semester;
  final String? tahunAjaran;

  Jadwal({
    this.id,
    this.mapel,
    this.guru,
    this.rombel,
    this.hari,
    this.jamMulai,
    this.jamSelesai,
    this.semester,
    this.tahunAjaran,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      id: json['id_jadwal'],
      mapel:
          (json['mapel'] != null && json['mapel'] is Map<String, dynamic>)
              ? (json['mapel']?['nama_mapel'])
              : 'Tidak Ada Mata Pelajaran',
      guru:
          (json['guru'] != null && json['guru'] is Map<String, dynamic>)
              ? (json['guru']?['nama'])
              : 'Tidak Ada Guru',
      rombel:
          (json['rombel'] != null && json['rombel'] is Map<String, dynamic>)
              ? (json['rombel']?['nama_rombel'])
              : 'Tidak Rombel',
      hari: json['hari']?.toString() ?? 'Tidak Ada Hari',
      jamMulai: json['jam_mulai']?.toString() ?? 'Tidak Diketahui',
      jamSelesai: json['jam_selesai']?.toString() ?? 'Tidak Diketahui',
      semester: json['semester']?.toString() ?? 'Tidak Ada Semester',
      tahunAjaran: json['tahun_ajaran']?.toString() ?? 'Tidak Ada Tahun Ajaran',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jadwal': id,
      'mapel': {'nama_mapel': mapel},
      'guru': {'nama': guru},
      'rombel': {'nama_rombel': rombel},
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'semester': semester,
      'tahun_ajaran': tahunAjaran,
    };
  }
}
