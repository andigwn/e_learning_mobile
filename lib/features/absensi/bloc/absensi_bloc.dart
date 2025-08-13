import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/absensi/data/model/absensi_model.dart';
import 'package:e_learning_mobile/features/absensi/domain/repository/absensi_repository.dart';
import 'package:equatable/equatable.dart';

part 'absensi_event.dart';
part 'absensi_state.dart';

class AbsensiBloc extends Bloc<AbsensiEvent, AbsensiState> {
  final AbsensiRepository repository;

  AbsensiBloc(this.repository) : super(AbsensiInitial()) {
    on<LoadAbsensiEvent>(_onLoadAbsensi);
    on<AbsenMasukEvent>(_onAbsenMasuk);
  }

  Future<void> _onLoadAbsensi(
    LoadAbsensiEvent event,
    Emitter<AbsensiState> emit,
  ) async {
    try {
      // Jika sudah ada data, kita tetap tampilkan loading indicator
      // tetapi tanpa menghilangkan data yang ada
      if (state is! AbsensiLoaded) {
        emit(AbsensiLoading());
      }

      final absensiList = await repository.getAbsensiBySiswaJadwal(
        siswaRombelId: event.siswaRombelId,
        jadwalId: event.jadwalId,
      );

      emit(AbsensiLoaded(absensiList));
    } catch (e) {
      // Jika sebelumnya ada data, kita pertahankan data tersebut
      if (state is AbsensiLoaded) {
        emit(
          AbsensiError(
            e.toString(),
            lastAbsensi: (state as AbsensiLoaded).absensiList,
          ),
        );
      } else {
        emit(AbsensiError(e.toString()));
      }
    }
  }

  Future<void> _onAbsenMasuk(
    AbsenMasukEvent event,
    Emitter<AbsensiState> emit,
  ) async {
    emit(AbsensiSubmitting());

    try {
      await repository.absenMasuk(
        siswaRombelId: event.siswaRombelId,
        jadwalId: event.jadwalId,
        latitude: event.latitude,
        longitude: event.longitude,
      );

      emit(AbsensiSuccess());

      // Muat ulang data setelah absen berhasil
      add(
        LoadAbsensiEvent(
          siswaRombelId: event.siswaRombelId,
          jadwalId: event.jadwalId,
        ),
      );
    } catch (e) {
      // Jika sebelumnya ada data, kita pertahankan data tersebut
      if (state is AbsensiLoaded) {
        emit(
          AbsensiError(
            e.toString(),
            lastAbsensi: (state as AbsensiLoaded).absensiList,
          ),
        );
      } else {
        emit(AbsensiError(e.toString()));
      }
    }
  }
}
