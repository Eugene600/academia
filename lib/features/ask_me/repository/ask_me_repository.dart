import 'dart:io';

import 'package:academia/features/ask_me/models/question.dart';
import 'package:academia/features/ask_me/repository/ask_me_remote_repository.dart';
import 'package:dartz/dartz.dart';

class AskMeRepository {
  final AskMeRemoteRepository _askMeRemoteRepository = AskMeRemoteRepository();

  Future<Either<String, List<T>>> fetchQuestions<T extends Question>(
      File file,
      String title,
      String userId,
      bool multiChoice,
      T Function(Map<String, dynamic>) fromJson) async {
    return await _askMeRemoteRepository.fetchQuestions(
        file, title, userId, multiChoice, fromJson);
  }
}
