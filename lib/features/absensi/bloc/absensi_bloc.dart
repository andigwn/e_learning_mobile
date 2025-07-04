import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/absensi/data/model/absensi_model.dart';
import 'package:e_learning_mobile/features/absensi/domain/repository/absensi_repository.dart';
import 'package:equatable/equatable.dart';

part 'absensi_event.dart';
part 'absensi_state.dart';

class AbsensiBloc extends Bloc<AbsensiEvent, AbsensiState> {
  final AbsensiRepository absensiRepository;
  List<Absensi> _lastAbsensiList = [];

  AbsensiBloc(this.absensiRepository) : super(AbsensiInitial()) {
    on<LoadAbsensi>((event, emit) async {
      emit(AbsensiLoading());
      try {
        final absensiList = await absensiRepository.fetchAbsensiSiswa(
          event.siswaId,
          event.jadwalId,
        );
        _lastAbsensiList = absensiList;
        emit(AbsensiLoaded(absensiList));
      } catch (e) {
        emit(AbsensiError(e.toString(), lastAbsensi: _lastAbsensiList));
      }
    });

    on<AbsenMasukEvent>((event, emit) async {
      emit(AbsensiButtonLoading());
      try {
        await absensiRepository.absenMasuk(
          siswaId: event.siswaId,
          jadwalId: event.jadwalId,
          tanggal: event.tanggal,
          status: event.status,
          latitude: event.latitude,
          longitude: event.longitude,
          alamatIp: event.alamatIp,
          deviceId: event.deviceId,
          statusVerifikasi: event.statusVerifikasi,
          verifikasiAbsensi: event.verifikasiAbsensi,
        );
        emit(AbsensiSuccess());
        // Fetch ulang data absensi
        final absensiList = await absensiRepository.fetchAbsensiSiswa(
          event.siswaId,
          event.jadwalId,
        );
        _lastAbsensiList = absensiList;
        emit(AbsensiLoaded(absensiList));
      } catch (e) {
        emit(AbsensiError(e.toString(), lastAbsensi: _lastAbsensiList));
      }
    });
  }
}
