part of 'dash_bloc.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentProfileLoaded extends StudentState {
  final Student student;

  StudentProfileLoaded(this.student);
}

class AllStudentsLoaded extends StudentState {
  final List<Student> students;

  AllStudentsLoaded(this.students);
}

class StudentError extends StudentState {
  final String message;

  StudentError(this.message);
}
