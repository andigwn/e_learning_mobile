part of 'absensi_bloc.dart';

abstract class AbsensiState extends Equatable {
  const AbsensiState();

  @override
  List<Object?> get props => [];
}

class AbsensiInitial extends AbsensiState {}

class AbsensiLoading extends AbsensiState {}

class AbsensiLoaded extends AbsensiState {
  final List<Absensi> absensiList;

  const AbsensiLoaded(this.absensiList);

  @override
  List<Object?> get props => [absensiList];
}

class AbsensiSuccess extends AbsensiState {}

class AbsensiError extends AbsensiState {
  final String message;
  final List<Absensi> lastAbsensi;

  const AbsensiError(this.message, {this.lastAbsensi = const []});

  @override
  List<Object?> get props => [message, lastAbsensi];
}

class AbsensiButtonLoading extends AbsensiState {}
