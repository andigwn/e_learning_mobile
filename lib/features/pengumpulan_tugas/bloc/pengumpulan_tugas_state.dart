part of 'pengumpulan_tugas_bloc.dart';

abstract class PengumpulanTugasState extends Equatable {
  const PengumpulanTugasState();

  @override
  List<Object> get props => [];
}

class PengumpulanTugasInitial extends PengumpulanTugasState {}

class PengumpulanTugasLoading extends PengumpulanTugasState {}

class PengumpulanTugasLoaded extends PengumpulanTugasState {
  final PengumpulanTugas? pengumpulan;

  const PengumpulanTugasLoaded(this.pengumpulan);

  @override
  List<Object> get props => [pengumpulan ?? Object()];
}

class PengumpulanTugasSubmitting extends PengumpulanTugasState {}

class PengumpulanTugasUpdating extends PengumpulanTugasState {}

class PengumpulanTugasSuccess extends PengumpulanTugasState {
  final String message;
  final PengumpulanTugas? pengumpulan;

  const PengumpulanTugasSuccess(this.message, {this.pengumpulan});

  @override
  List<Object> get props => [message, pengumpulan ?? Object()];
}

class PengumpulanTugasError extends PengumpulanTugasState {
  final String message;
  final PengumpulanTugas? lastPengumpulan;

  const PengumpulanTugasError(this.message, {this.lastPengumpulan});

  @override
  List<Object> get props => [message, lastPengumpulan ?? Object()];
}

// [NEW STATE] Untuk riwayat pengumpulan tugas siswa
class RiwayatPengumpulanTugasSiswaLoading extends PengumpulanTugasState {}

class RiwayatPengumpulanTugasSiswaLoaded extends PengumpulanTugasState {
  final List<PengumpulanTugas> riwayat;
  final bool hasMore;

  const RiwayatPengumpulanTugasSiswaLoaded({
    required this.riwayat,
    this.hasMore = true,
  });

  @override
  List<Object> get props => [riwayat, hasMore];
}
