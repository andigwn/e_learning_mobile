class Student {
  final int? id;
  final String? name;
  final String? nis;
  final String? major; // Diambil dari jurusan.nama_jurusan
  final String? gender;
  final String? birthPlace;
  final String? birthDate;
  final String? address;
  final String? phone;
  final String? imageUrl;
  final String? classroom; // Diambil dari ruangan.nama_ruangan (rombel)

  Student({
    this.id,
    this.name,
    this.nis,
    this.major,
    this.gender,
    this.birthPlace,
    this.birthDate,
    this.address,
    this.phone,
    this.imageUrl,
    this.classroom,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id_siswa'],
      name: json['nama_siswa'],
      nis: json['nis'].toString(),
      major: json['jurusan']?['nama_jurusan'] ?? 'Tidak ada jurusan',
      gender: json['jenis_kelamin'] == 'PRIA' ? 'Laki-laki' : 'Perempuan',
      birthPlace: json['tempat'] ?? 'Tidak diketahui',
      birthDate: json['tanggal_lahir'] ?? 'Tidak diketahui',
      address: _buildFullAddress(json),
      phone: json['no_hp'] ?? 'Tidak ada nomor HP',
      imageUrl: json['image'] ?? 'default_profile.jpg',
      classroom: json['ruangan']?['kode_kelas'] ?? 'Kelas belum ditentukan',
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
}
