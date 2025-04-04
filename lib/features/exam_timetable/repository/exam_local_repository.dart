import 'package:academia/database/database.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';

final class ExamLocalRepository {
  // the db's instance
  final AppDatabase _localDb = GetIt.instance.get(instanceName: "cacheDB");

  /// Fetches all cached exams
  /// Incase of an error a message of type [String] is returned
  /// On success, a [List] of [ExamModelData] is returned
  Future<Either<String, List<ExamModelData>>> fetchAllCachedExams() async {
    try {
      final exams = await _localDb.select(_localDb.examModel).get();
      return right(exams);
    } catch (e) {
      return left("Failed to retrieve exam with error message ${e.toString()}");
    }
  }

  /// Adds a [ExamModelData] specified by [exam] to [_localDb] cache
  /// This method can also be used to update exams since it also updates the
  /// information on conflict
  Future<Either<String, bool>> addExamToCache(ExamModelData exam) async {
    try {
      final ok = await _localDb.into(_localDb.examModel).insert(
            exam.toCompanion(true),
            mode: InsertMode.insertOrReplace,
          );
      if (ok != 0) {
        return right(true);
      }
      return left(
        "The specified exam data was not inserted since it exists and conflicted",
      );
    } catch (e) {
      return left(
        "Failed to append exam to cache with error description ${e.toString()}",
      );
    }
  }

  /// Delete the [ExamModelData] specified by [exam] from local cache
  /// It wil return an instance of [String] describing the error that it might have
  /// encountered or a boolean [true] incase it was a success
  Future<Either<String, bool>> deleteExamFromCache(ExamModelData exam) async {
    try {
      final ok = await _localDb.delete(_localDb.examModel).delete(exam);
      if (ok != 0) {
        return right(true);
      }
      return right(true);
    } catch (e) {
      return left(
        "Failed to delete exam from cache with error description ${e.toString()}",
      );
    }
  }
}
