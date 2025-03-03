part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

final class AttendanceMarkingRequested extends AttendanceEvent {
  final AttendanceModelData record;
  AttendanceMarkingRequested({required this.record});
}
