part of 'jadwal_bloc.dart';

abstract class JadwalEvent {}

class LoadJadwal extends JadwalEvent {
  final int rombelId;
  LoadJadwal(this.rombelId);
}
