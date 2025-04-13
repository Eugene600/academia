import 'package:academia/features/ask_me/models/question.dart';
import 'package:academia/utils/network/network.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AskMeRemoteRepository with DioErrorHandler {
  final DioClient _client = DioClient();

  Future<Either<String, List<T>>> fetchQuestions<T extends Question>(
      String file,
      String title,
      String userId,
      bool multiChoice,
      T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await _client.dio.post('api/upload/', queryParameters: {
        'pdf_file': file,
        'title': title,
        'user_id': userId,
        'multi_choice': multiChoice.toString(),
      });
      final questions = (response.data as List)
          .map((q) => fromJson(q as Map<String, dynamic>))
          .cast<T>()
          .toList();
      return Right(questions);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      return left("Something went terribly wrong please retry that action");
    }
  }
}
