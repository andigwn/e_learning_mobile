import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/domain/repository/pengumpulan_tugas_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/data/model/pengumpulan_tugas_model.dart';
import 'package:intl/intl.dart';
part 'pengumpulan_tugas_event.dart';
part 'pengumpulan_tugas_state.dart';

class PengumpulanTugasBloc
    extends Bloc<PengumpulanTugasEvent, PengumpulanTugasState> {
  final PengumpulanTugasRepository repository;
  List<PengumpulanTugas> _lastPengumpulan = [];

  PengumpulanTugasBloc(this.repository) : super(PengumpulanTugasInitial()) {
    on<LoadPengumpulanTugas>((event, emit) async {
      emit(PengumpulanTugasLoading());
      try {
        final list = await repository.getPengumpulanTugasBySiswa(
          event.siswaId,
          event.tugasId,
        );
        _lastPengumpulan = list;
        emit(PengumpulanTugasLoaded(list));
      } catch (e) {
        emit(PengumpulanTugasError(e.toString(), lastData: _lastPengumpulan));
      }
    });

    on<SubmitTugas>((event, emit) async {
      emit(PengumpulanTugasSubmitting());
      try {
        final now = DateTime.now();
        final formattedDate = DateFormat(
          'yyyy-MM-dd',
        ).format(now); // Format hanya tanggal
        await repository.submitTugas(
          siswaId: event.siswaId,
          tugasId: event.tugasId,
          linkTugas: event.linkTugas,
          tanggalPengumpulan: formattedDate,
        );
        emit(PengumpulanTugasSuccess());
        add(
          LoadPengumpulanTugas(siswaId: event.siswaId, tugasId: event.tugasId),
        );
      } catch (e) {
        emit(PengumpulanTugasError(e.toString(), lastData: _lastPengumpulan));
      }
    });
  }
} // To parse this JSON data, do
