import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/tugas/data/model/tugas_model.dart';
import 'package:e_learning_mobile/features/tugas/domain/respository/tugas_repo.dart';
import 'package:equatable/equatable.dart';

part 'tugas_event.dart';
part 'tugas_state.dart';

class TugasBloc extends Bloc<TugasEvent, TugasState> {
  final TugasRepo repository;

  TugasBloc(this.repository) : super(TugasInitial()) {
    on<LoadTugas>(_onLoadTugas);
  }

  Future<void> _onLoadTugas(LoadTugas event, Emitter<TugasState> emit) async {
    emit(TugasLoading());
    try {
      final tugas = await repository.getTugas(event.jadwalId);

      if (tugas.isEmpty) {
        emit(TugasEmpty());
      } else {
        emit(TugasLoaded(tugas));
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(TugasError(errorMessage));
    }
  }
}
