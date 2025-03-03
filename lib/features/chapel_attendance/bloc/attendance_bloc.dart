import 'package:academia/database/database.dart';
import 'package:academia/features/chapel_attendance/repository/attendance_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'attendance_state.dart';
part 'attendance_event.dart';

final class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final Logger _logger = Logger();
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  AttendanceBloc() : super(AttendanceInitialState()) {
    _logger.i("Chapel attandance bloc initialized");

    on<AttendanceMarkingRequested>((event, emit) async {
      emit(AttendanceLoadingState());

      final result = await _attendanceRepository.markAttendance(event.record);
      return result.fold((error) {
        _logger.e(error);
        return emit(AttendaceErrorState(error: error));
      }, (message) {
        _logger.i("Attendance marked successfully");
        return emit(AttendanceMarkedState(message: message));
      });
    });
  }
}
