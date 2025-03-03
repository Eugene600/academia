part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitialState extends AttendanceState {}

final class AttendanceLoadingState extends AttendanceState {}

final class AttendaceErrorState extends AttendanceState {
  final String error;
  AttendaceErrorState({required this.error});
}

final class AttendanceMarkedState extends AttendanceState {
  final String message;
  AttendanceMarkedState({required this.message});
}
