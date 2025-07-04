part of 'absensi_bloc.dart';

abstract class AbsensiEvent extends Equatable {
  const AbsensiEvent();

  @override
  List<Object?> get props => [];
}

class LoadAbsensi extends AbsensiEvent {
  final int siswaId;
  final int jadwalId;

  const LoadAbsensi({required this.siswaId, required this.jadwalId});

  @override
  List<Object?> get props => [siswaId, jadwalId];
}

class AbsenMasukEvent extends AbsensiEvent {
  final int siswaId;
  final int jadwalId;
  final String tanggal;
  final String status;
  final double latitude;
  final double longitude;
  final String alamatIp;
  final String deviceId;
  final String statusVerifikasi;
  final String verifikasiAbsensi;

  const AbsenMasukEvent({
    required this.siswaId,
    required this.jadwalId,
    required this.tanggal,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.alamatIp,
    required this.deviceId,
    required this.statusVerifikasi,
    required this.verifikasiAbsensi,
  });

  @override
  List<Object?> get props => [
    siswaId,
    jadwalId,
    tanggal,
    status,
    latitude,
    longitude,
    alamatIp,
    deviceId,
    statusVerifikasi,
    verifikasiAbsensi,
  ];
}
