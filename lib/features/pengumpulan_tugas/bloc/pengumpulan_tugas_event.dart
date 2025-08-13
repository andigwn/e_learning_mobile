part of 'pengumpulan_tugas_bloc.dart';

abstract class PengumpulanTugasEvent extends Equatable {
  const PengumpulanTugasEvent();

  @override
  List<Object?> get props => []; // Changed to Object?
}

// class LoadPengumpulanSiswa extends PengumpulanTugasEvent {
//   final int tugasId;
//   final int siswaRombelId;

//   const LoadPengumpulanSiswa({
//     required this.tugasId,
//     required this.siswaRombelId,
//   });

//   @override
//   List<Object?> get props => [tugasId, siswaRombelId]; // Changed to Object?
// }

class SubmitTugas extends PengumpulanTugasEvent {
  final int tugasId;
  final String linkTugas;
  final String tanggalPengumpulan;

  const SubmitTugas({
    required this.tugasId,
    required this.linkTugas,
    required this.tanggalPengumpulan,
  });

  @override
  List<Object?> get props => [tugasId, linkTugas, tanggalPengumpulan]; // Changed to Object?
}

class UpdatePengumpulan extends PengumpulanTugasEvent {
  final int idPengumpulan;
  final String linkTugas;
  final String tanggalPengumpulan;

  const UpdatePengumpulan({
    required this.idPengumpulan,
    required this.linkTugas,
    required this.tanggalPengumpulan,
  });

  @override
  List<Object?> get props => [idPengumpulan, linkTugas, tanggalPengumpulan]; // Changed to Object?
}

class LoadRiwayatPengumpulanTugasSiswa extends PengumpulanTugasEvent {
  final int siswaRombelId;
  final int? tugasId;
  final String? tanggalPengumpulan;
  final String? status;
  final int page;
  final int size;

  const LoadRiwayatPengumpulanTugasSiswa({
    required this.siswaRombelId,
    this.tugasId,
    this.tanggalPengumpulan,
    this.status,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [
    siswaRombelId,
    tugasId,
    tanggalPengumpulan,
    status,
    page,
    size,
  ];
}
