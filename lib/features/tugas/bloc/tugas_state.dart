part of 'tugas_bloc.dart';

sealed class TugasState extends Equatable {
  const TugasState();

  @override
  List<Object> get props => [];
}

final class TugasInitial extends TugasState {}

final class TugasLoading extends TugasState {}

final class TugasLoaded extends TugasState {
  final List<Tugas> tugas;

  const TugasLoaded(this.tugas);

  @override
  List<Object> get props => [tugas];
}

final class TugasError extends TugasState {
  final String message;

  const TugasError(this.message);

  @override
  List<Object> get props => [message];
}
