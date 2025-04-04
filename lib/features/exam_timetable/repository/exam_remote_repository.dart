import 'package:academia/database/database.dart';
import 'package:academia/utils/network/network.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

final class ExamRemoteRepository with DioErrorHandler {
  final DioClient _dioClient = DioClient();

  /// Fetches courses from magnet.
  Future<Either<String, List<ExamModelData>>> fetchExamsFromRemote(
    List<String> courses,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        "/merlin/timetables/exams/",
        data: {"course_codes": courses},
      );

      if (response.statusCode == 200) {
        final exams =
            response.data.map((e) => ExamModelData.fromJson(e)).toList();
        return right(exams.cast<ExamModelData>());
      }

      throw "Jeezz";
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      return left("Something went terribly wrong please try that later");
    }
  }
}
