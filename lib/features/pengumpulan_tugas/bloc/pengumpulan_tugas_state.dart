part of 'pengumpulan_tugas_bloc.dart';

abstract class PengumpulanTugasState extends Equatable {
  const PengumpulanTugasState();

  @override
  List<Object> get props => [];
}

class PengumpulanTugasInitial extends PengumpulanTugasState {}

class PengumpulanTugasLoading extends PengumpulanTugasState {}

class PengumpulanTugasLoaded extends PengumpulanTugasState {
  final List<PengumpulanTugas> listTugas;

  const PengumpulanTugasLoaded(this.listTugas);

  @override
  List<Object> get props => [listTugas];
}

class PengumpulanTugasSubmitting extends PengumpulanTugasState {}

class PengumpulanTugasSuccess extends PengumpulanTugasState {}

class PengumpulanTugasError extends PengumpulanTugasState {
  final String message;
  final List<PengumpulanTugas>? lastData;

  const PengumpulanTugasError(this.message, {this.lastData});

  @override
  List<Object> get props => [message];
}
