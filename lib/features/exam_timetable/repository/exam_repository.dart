import 'package:academia/database/database.dart';
import 'package:academia/features/exam_timetable/repository/exam_local_repository.dart';
import 'package:academia/features/exam_timetable/repository/exam_remote_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

final class ExamRepository {
  final ExamRemoteRepository _examRemoteRepository = ExamRemoteRepository();
  final ExamLocalRepository _examLocalRepository = ExamLocalRepository();
  final Logger _logger = Logger();

  Future<Either<String, List<ExamModelData>>> fetchExams(
      List<String> courses) async {
    final remoteResponse =
        await _examRemoteRepository.fetchExamsFromRemote(courses);
    return remoteResponse.fold((error) {
      _logger.e("Failed to fetch exams", error: error);
      return left(error);
    }, (exams) {
      return right(exams);
    });
  }

  Future<Either<String, List<ExamModelData>>> fetchCachedExams() async {
    return await _examLocalRepository.fetchAllCachedExams();
  }

  Future<Either<String, bool>> clearAllCachedExams() async {
    final res = await fetchCachedExams();
    return res.fold((error) {
      return left(error);
    }, (exams) async {
      for (var exam in exams) {
        final res = await removeExamFromCache(exam);
        if (res.isLeft()) {
          return left((res as Left).value);
        }
      }
      return right(true);
    });
  }

  Future<Either<String, bool>> addExamToCache(ExamModelData exam) async {
    return await _examLocalRepository.addExamToCache(exam);
  }

  Future<Either<String, bool>> removeExamFromCache(ExamModelData exam) async {
    return await _examLocalRepository.deleteExamFromCache(exam);
  }
}
