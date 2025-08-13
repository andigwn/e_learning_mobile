import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/domain/repository/pengumpulan_tugas_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/data/model/pengumpulan_tugas_model.dart';
part 'pengumpulan_tugas_event.dart';
part 'pengumpulan_tugas_state.dart';

class PengumpulanTugasBloc
    extends Bloc<PengumpulanTugasEvent, PengumpulanTugasState> {
  final PengumpulanTugasRepository repository;
  PengumpulanTugas? _currentPengumpulan;

  // Untuk menyimpan riwayat
  List<PengumpulanTugas> _riwayatPengumpulan = [];
  bool _hasMore = true;

  PengumpulanTugasBloc(this.repository) : super(PengumpulanTugasInitial()) {
    // on<LoadPengumpulanSiswa>((event, emit) async {
    //   emit(PengumpulanTugasLoading());
    //   try {
    //     final pengumpulan = await repository.getPengumpulanSiswa(
    //       event.tugasId,
    //       event.siswaRombelId,
    //     );
    //     _currentPengumpulan = pengumpulan;
    //     emit(PengumpulanTugasLoaded(pengumpulan));
    //   } catch (e) {
    //     emit(
    //       PengumpulanTugasError(
    //         e.toString(),
    //         lastPengumpulan: _currentPengumpulan,
    //       ),
    //     );
    //   }
    // });

    on<SubmitTugas>((event, emit) async {
      emit(PengumpulanTugasSubmitting());
      try {
        final pengumpulan = await repository.submitTugas(
          tugasId: event.tugasId,
          linkTugas: event.linkTugas,
          tanggalPengumpulan: event.tanggalPengumpulan,
        );
        _currentPengumpulan = pengumpulan;
        emit(
          PengumpulanTugasSuccess(
            'Tugas berhasil dikumpulkan',
            pengumpulan: pengumpulan,
          ),
        );
      } catch (e) {
        emit(
          PengumpulanTugasError(
            e.toString(),
            lastPengumpulan: _currentPengumpulan,
          ),
        );
      }
    });

    on<UpdatePengumpulan>((event, emit) async {
      emit(PengumpulanTugasUpdating());
      try {
        final pengumpulan = await repository.updatePengumpulanSiswa(
          idPengumpulan: event.idPengumpulan,
          linkTugas: event.linkTugas,
          tanggalPengumpulan: event.tanggalPengumpulan,
        );
        _currentPengumpulan = pengumpulan;
        emit(
          PengumpulanTugasSuccess(
            'Pengumpulan tugas berhasil diperbarui',
            pengumpulan: pengumpulan,
          ),
        );
      } catch (e) {
        emit(
          PengumpulanTugasError(
            e.toString(),
            lastPengumpulan: _currentPengumpulan,
          ),
        );
      }
    });

    // [NEW EVENT HANDLER] Untuk memuat riwayat pengumpulan tugas siswa
    on<LoadRiwayatPengumpulanTugasSiswa>((event, emit) async {
      // Reset data jika halaman pertama
      if (event.page == 1) {
        _riwayatPengumpulan = [];
        _hasMore = true;
        emit(RiwayatPengumpulanTugasSiswaLoading());
      }

      try {
        final riwayat = await repository.getRiwayatPengumpulanTugasSiswa(
          siswaRombelId: event.siswaRombelId,
          tugasId: event.tugasId,
          tanggalPengumpulan: event.tanggalPengumpulan,
          status: event.status,
          page: event.page,
          size: event.size,
        );

        // Update state
        _riwayatPengumpulan = [..._riwayatPengumpulan, ...riwayat];
        _hasMore = riwayat.length >= event.size;

        emit(
          RiwayatPengumpulanTugasSiswaLoaded(
            riwayat: _riwayatPengumpulan,
            hasMore: _hasMore,
          ),
        );
      } catch (e) {
        emit(
          PengumpulanTugasError(
            e.toString(),
            lastPengumpulan: _currentPengumpulan,
          ),
        );
      }
    });
  }

  // [HELPER] Reset riwayat pagination
  void resetRiwayat() {
    _riwayatPengumpulan = [];
    _hasMore = true;
  }
}
