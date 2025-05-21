import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:e_learning_mobile/features/jadwal/domain/repositories/jadwal_repo.dart';

part 'jadwal_event.dart';
part 'jadwal_state.dart';

class JadwalBloc extends Bloc<JadwalEvent, JadwalState> {
  final JadwalRepo repository;
  JadwalBloc(this.repository) : super(JadwalInitial()) {
    on<LoadJadwal>(_onLoadJadwal);
  }
  Future<void> _onLoadJadwal(
    LoadJadwal event,
    Emitter<JadwalState> emit,
  ) async {
    emit(JadwalLoading());
    try {
      final jadwal = await repository.getJadwal();
      emit(JadwalLoaded(jadwal));
    } catch (e) {
      emit(JadwalError(e.toString()));
    }
  }
}
