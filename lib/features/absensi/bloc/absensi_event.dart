part of 'absensi_bloc.dart';

abstract class AbsensiEvent extends Equatable {
  const AbsensiEvent();

  @override
  List<Object?> get props => [];
}

class LoadAbsensiEvent extends AbsensiEvent {
  final int siswaRombelId;
  final int jadwalId;

  const LoadAbsensiEvent({required this.siswaRombelId, required this.jadwalId});

  @override
  List<Object?> get props => [siswaRombelId, jadwalId];
}

class AbsenMasukEvent extends AbsensiEvent {
  final int siswaRombelId;
  final int jadwalId;
  final double latitude;
  final double longitude;

  const AbsenMasukEvent({
    required this.siswaRombelId,
    required this.jadwalId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [siswaRombelId, jadwalId, latitude, longitude];
}
