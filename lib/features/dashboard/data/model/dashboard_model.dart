class Student {
  final int? id;
  final String? name;
  final String? nis;
  final String? major; // Diambil dari jurusan.nama_jurusan
  final String? gender;
  final String? birthPlace;
  final String? birthDate;
  final String? address;
  final String? imageUrl;
  final int? rombelId; // Diambil dari ruangan.nama_ruangan (rombel)
  final String? rombelName; // Diambil dari ruangan.nama_ruangan (rombel)

  Student({
    this.id,
    this.name,
    this.nis,
    this.major,
    this.gender,
    this.birthPlace,
    this.birthDate,
    this.address,
    this.imageUrl,
    this.rombelId,
    this.rombelName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    // Cari id siswa dari beberapa kemungkinan key
    dynamic idRaw = json['id_siswa'] ?? json['id'] ?? json['id_users'];
    int? id;
    if (idRaw is String) {
      id = int.tryParse(idRaw);
    } else if (idRaw is int) {
      id = idRaw;
    }
    // Cari NIS
    String? nis = json['nis']?.toString() ?? json['nisn']?.toString();
    // Gender
    String? gender;
    if (json['jenis_kelamin'] != null) {
      final jk = json['jenis_kelamin'].toString().toLowerCase();
      if (jk == 'pria' || jk == 'laki-laki' || jk == 'laki') {
        gender = 'Laki-laki';
      } else if (jk == 'perempuan' || jk == 'wanita') {
        gender = 'Perempuan';
      } else {
        gender = json['jenis_kelamin'].toString();
      }
    }
    // Rombel id
    dynamic rombelIdRaw = json['rombel']?['id_rombel'] ?? json['id_rombel'];
    int? rombelId;
    if (rombelIdRaw is String) {
      rombelId = int.tryParse(rombelIdRaw);
    } else if (rombelIdRaw is int) {
      rombelId = rombelIdRaw;
    }
    return Student(
      id: id,
      name: json['nama_siswa'] ?? json['name'],
      nis: nis,
      major:
          json['jurusan']?['nama_jurusan'] ??
          json['major'] ??
          'Tidak ada jurusan',
      gender: gender,
      birthPlace: json['tempat'] ?? json['birthPlace'] ?? 'Tidak diketahui',
      birthDate:
          json['tanggal_lahir'] ?? json['birthDate'] ?? 'Tidak diketahui',
      address: _buildFullAddress(json),
      imageUrl: json['image'] ?? json['imageUrl'] ?? 'default_profile.jpg',
      rombelId: rombelId,
      rombelName: json['rombel']?['nama_rombel'] ?? json['rombelName'],
    );
  }

  static String _buildFullAddress(Map<String, dynamic> json) {
    final alamat = json['alamat'] ?? '';
    final rt = json['rt'] != null ? 'RT ${json['rt']}' : '';
    final rw = json['rw'] != null ? 'RW ${json['rw']}' : '';
    final dusun = json['dusun'] ?? '';
    final kelurahan = json['kelurahan'] ?? '';
    final kecamatan = json['kecamatan'] ?? '';

    return [
      alamat,
      if (rt.isNotEmpty && rw.isNotEmpty) '$rt/$rw',
      dusun,
      kelurahan,
      kecamatan,
    ].where((part) => part.isNotEmpty).join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id_siswa': id,
      'nama_siswa': name,
      'nis': nis,
      'jurusan': {'nama_jurusan': major},
      'jenis_kelamin': gender,
      'tempat': birthPlace,
      'tanggal_lahir': birthDate,
      'alamat': address,
      'image': imageUrl,
      'rombel': {'id_rombel': rombelId, 'nama_rombel': rombelName},
      'id_rombel': rombelId,
      'rombelName': rombelName,
    };
  }
}
