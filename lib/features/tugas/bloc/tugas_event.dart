part of 'tugas_bloc.dart';

abstract class TugasEvent {}

class LoadTugas extends TugasEvent {
  final int jadwalId;

  LoadTugas(this.jadwalId);
}
