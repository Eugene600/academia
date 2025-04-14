part of 'ask_me_bloc.dart';

sealed class AskMeState {}

final class AskMeInitialState extends AskMeState {}

final class AskMeLoadingState extends AskMeState {}

final class AskMeErrorState extends AskMeState {
  final String error;
  AskMeErrorState({required this.error});
}

final class QuestionsStateLoaded extends AskMeState {
  final List<Question> questions;
  final int timeLimit;

  QuestionsStateLoaded({required this.questions, required this.timeLimit});
}

final class QuestionInProgress extends AskMeState {
  final List<Question> allQuestions;
  final Question currentQuestion;
  final int questionIndex;
  final int score;
  final int total;
  final int timeLimit;
  final int remainingSeconds;
  final int? selectedOptionIndex;

  QuestionInProgress({
    required this.allQuestions,
    required this.currentQuestion,
    required this.questionIndex,
    required this.score,
    required this.total,
    required this.timeLimit,
    required this.remainingSeconds,
    this.selectedOptionIndex,
  });
}

final class AnswerResultState extends AskMeState {
  final List<Question> allQuestions;
  final Question currentQuestion;
  final int questionIndex;
  final int score;
  final int total;
  final int timeLimit;
  final int remainingSeconds;
  final String selectedAnswer;
  final int? selectedOptionIndex;
  final bool isCorrect;

  AnswerResultState({
    required this.allQuestions,
    required this.currentQuestion,
    required this.questionIndex,
    required this.score,
    required this.total,
    required this.timeLimit,
    required this.remainingSeconds,
    required this.selectedAnswer,
    this.selectedOptionIndex,
    required this.isCorrect,
  });
}

final class QuestionsComplete extends AskMeState {
  final int score;
  final int total;

  QuestionsComplete({required this.score, required this.total});
}
