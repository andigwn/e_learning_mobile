class Jadwal {
  final int? id;
  final String? mapel;
  final String? guru;
  final String? siswa;
  final String? kelas;
  final String? ruangan;
  final String? hari;
  final String? tipe;
  final String? jamMulai;
  final String? jamSelesai;
  final String? semester;
  final String? tahunAjaran;
  final String? status;

  Jadwal({
    this.id,
    this.mapel,
    this.guru,
    this.siswa,
    this.kelas,
    this.ruangan,
    this.hari,
    this.tipe,
    this.jamMulai,
    this.jamSelesai,
    this.semester,
    this.tahunAjaran,
    this.status,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    String? getNestedString(
      dynamic parent,
      String key, [
      String? defaultValue,
    ]) {
      if (parent is Map<String, dynamic> && parent[key] != null) {
        return parent[key].toString();
      }
      return defaultValue;
    }

    return Jadwal(
      id: json['id_jadwal'],
      mapel: getNestedString(
        json['mapel'],
        'nama_mapel',
        'Tidak Ada Mata Pelajaran',
      ),
      guru: getNestedString(json['guru'], 'nama', 'Tidak Ada Nama Guru'),
      siswa: getNestedString(
        json['siswa'],
        'nama_siswa',
        'Tidak Ada Nama Siswa',
      ),
      kelas: getNestedString(
        json['kelas'],
        'nama_kelas',
        'Tidak Ada Nama Kelas',
      ),
      ruangan: getNestedString(
        json['ruangan'],
        'nama_ruangan',
        'Tidak Ada Nama Ruangan',
      ),
      hari: json['hari']?.toString() ?? 'Tidak Ada Hari',
      tipe: json['tipe']?.toString() ?? 'Tidak Ada Tipe',
      jamMulai: json['jam_mulai']?.toString() ?? 'Tidak Diketahui',
      jamSelesai: json['jam_selesai']?.toString() ?? 'Tidak Diketahui',
      semester: json['semester']?.toString() ?? 'Tidak Ada Semester',
      tahunAjaran: json['tahun_ajaran']?.toString() ?? 'Tidak Ada Tahun Ajaran',
      status: json['status']?.toString() ?? 'Tidak Ada Status',
    );
  }
}
