import 'package:academia/database/database.dart';
import 'package:academia/features/chapel_attendance/repository/attendance_remote_repository.dart';
import 'package:dartz/dartz.dart';

final class AttendanceRepository {
  final AttendanceRemoteRepository _attendanceRemoteRepository =
      AttendanceRemoteRepository();

  Future<Either<String, String>> markAttendance(
    AttendanceModelData record,
  ) async {
    return await _attendanceRemoteRepository.markAttendance(record);
  }
}
