import 'dart:io';

import 'package:academia/features/ask_me/models/question.dart';
import 'package:academia/utils/network/network.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AskMeRemoteRepository with DioErrorHandler {
  final DioClient _client = DioClient();

  Future<Either<String, List<T>>> fetchQuestions<T extends Question>(
      File file,
      String title,
      String userId,
      bool multiChoice,
      T Function(Map<String, dynamic>) fromJson) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'pdf_file': await MultipartFile.fromFile(file.path, filename: fileName),
        'title': title,
        'user_id': userId,
        'multi_choice': multiChoice.toString(),
      });

      final response = await _client.dio
          .post('http://62.169.16.219:83/api/upload/', data: formData);

      final questions = (response.data['questions'] as List)
          .map((q) => fromJson(q as Map<String, dynamic>))
          .cast<T>()
          .toList();
      return Right(questions);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      print("Caught generic exception: $e");
      return left("Something went terribly wrong please retry that action");
    }
  }
}
