part of 'jadwal_bloc.dart';

abstract class JadwalState {}

final class JadwalInitial extends JadwalState {}

final class JadwalLoading extends JadwalState {}

final class JadwalLoaded extends JadwalState {
  final List<Jadwal> jadwal;

  JadwalLoaded(this.jadwal);
}

final class JadwalError extends JadwalState {
  final String message;

  JadwalError(this.message);
}
