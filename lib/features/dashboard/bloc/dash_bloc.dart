import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';

part 'dash_event.dart';
part 'dash_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository repository;

  StudentBloc(this.repository) : super(StudentInitial()) {
    on<LoadStudentProfile>(_onLoadProfile);
    on<LoadAllStudents>(_onLoadAllStudents);
  }

  Future<void> _onLoadProfile(
    LoadStudentProfile event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final student = await repository.getStudentProfile();
      emit(StudentProfileLoaded(student));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onLoadAllStudents(
    LoadAllStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final students = await repository.getAllStudents();
      emit(AllStudentsLoaded(students));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }
}
