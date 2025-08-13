part of 'dash_bloc.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentDashboardLoaded extends StudentState {
  final DashboardResponse dashboard;

  StudentDashboardLoaded(this.dashboard);
}

class AllStudentsLoaded extends StudentState {
  final List<Student> students;

  AllStudentsLoaded(this.students);
}

class StudentError extends StudentState {
  final String message;

  StudentError(this.message);
}
