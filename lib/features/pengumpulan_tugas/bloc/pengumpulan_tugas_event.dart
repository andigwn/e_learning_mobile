part of 'pengumpulan_tugas_bloc.dart';

abstract class PengumpulanTugasEvent extends Equatable {
  const PengumpulanTugasEvent();

  @override
  List<Object> get props => [];
}

class LoadPengumpulanTugas extends PengumpulanTugasEvent {
  final int siswaId;
  final int tugasId;

  const LoadPengumpulanTugas({required this.siswaId, required this.tugasId});

  @override
  List<Object> get props => [siswaId, tugasId];
}

class SubmitTugas extends PengumpulanTugasEvent {
  final int siswaId;
  final int tugasId;
  final String linkTugas;
  final String tanggalPengumpulan;

  const SubmitTugas({
    required this.siswaId,
    required this.tugasId,
    required this.linkTugas,
    required this.tanggalPengumpulan,
  });

  @override
  List<Object> get props => [siswaId, tugasId, linkTugas, tanggalPengumpulan];
}
