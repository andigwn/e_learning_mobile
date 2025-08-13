class DashboardResponse {
  final int id;
  final int idRombel;
  final int idSiswa;
  final int idPeriode;
  final Student siswa;
  final Rombel rombel;
  final Periode periode;

  DashboardResponse({
    required this.id,
    required this.idRombel,
    required this.idSiswa,
    required this.idPeriode,
    required this.siswa,
    required this.rombel,
    required this.periode,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      id: json['id'],
      idRombel: json['id_rombel'],
      idSiswa: json['id_siswa'],
      idPeriode: json['id_periode'],
      siswa: Student.fromJson(json['siswa']),
      rombel: Rombel.fromJson(json['rombel']),
      periode: Periode.fromJson(json['periode']),
    );
  }
}

class Rombel {
  final int id;
  final String nama;
  final int jumlahSiswa;
  final String kodeJurusan;
  final Map<String, dynamic> jurusan;
  final int idRuangan;

  Rombel({
    required this.id,
    required this.nama,
    required this.jumlahSiswa,
    required this.kodeJurusan,
    required this.jurusan,
    required this.idRuangan,
  });

  factory Rombel.fromJson(Map<String, dynamic> json) {
    return Rombel(
      id: json['id_rombel'],
      nama: json['nama_rombel'],
      jumlahSiswa: json['jumlah_siswa'],
      kodeJurusan: json['kode_jurusan'],
      idRuangan: json['id_ruangan'],
      jurusan:
          json['jurusan'] is Map
              ? Map<String, dynamic>.from(json['jurusan'])
              : {},
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'jurusan': jurusan,
    'nama': nama,
    'jumlah_siswa': jumlahSiswa,
    'kode_jurusan': kodeJurusan,
    'id_ruangan': idRuangan,
  };
}

class Periode {
  final int id;
  final String jenisPeriode;
  final String nama;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String semester;
  final String tahunAjaran;
  final bool isActive;

  Periode({
    required this.id,
    required this.jenisPeriode,
    required this.nama,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.semester,
    required this.tahunAjaran,
    required this.isActive,
  });

  factory Periode.fromJson(Map<String, dynamic> json) {
    return Periode(
      id: json['id_periode'],
      jenisPeriode: json['jenis_periode'],
      nama: json['nama'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalSelesai: DateTime.parse(json['tanggal_selesai']),
      semester: json['semester'],
      tahunAjaran: json['tahun_ajaran'],
      isActive: json['is_active'],
    );
  }
}

class Student {
  final int id;
  // final int idSiswaRombel;
  final int idUsers;
  final String nis;
  final String nisn;
  final String name;
  final String birthPlace;
  final DateTime birthDate;
  final String religion;
  final int rt;
  final int rw;
  final String dusun;
  final String kelurahan;
  final String kecamatan;
  final int kodePos;
  final String address;
  final String gender;
  final String imageUrl;

  Student({
    required this.id,
    // required this.idSiswaRombel,
    required this.idUsers,
    required this.nis,
    required this.nisn,
    required this.name,
    required this.birthPlace,
    required this.birthDate,
    required this.religion,
    required this.rt,
    required this.rw,
    required this.dusun,
    required this.kelurahan,
    required this.kecamatan,
    required this.kodePos,
    required this.address,
    required this.gender,
    required this.imageUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id_siswa'],
      // idSiswaRombel: json['id_siswa_rombel'],
      idUsers: json['id_users'],
      nis: json['nis'].toString(),
      nisn: json['nisn'].toString(),
      name: json['nama_siswa'],
      birthPlace: json['tempat_lahir'],
      birthDate: DateTime.parse(json['tanggal_lahir']),
      religion: json['agama'],
      rt: json['rt'],
      rw: json['rw'],
      dusun: json['dusun'],
      kelurahan: json['kelurahan'],
      kecamatan: json['kecamatan'],
      kodePos: json['kode_pos'],
      address: json['alamat'],
      gender: json['jenis_kelamin'] == 'L' ? 'Laki-laki' : 'Perempuan',
      imageUrl: json['image'],
    );
  }
}
