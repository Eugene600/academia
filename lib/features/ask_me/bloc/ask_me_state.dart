part of 'ask_me_bloc.dart';

sealed class AskMeState {}

final class AskMeInitialState extends AskMeState {}

final class AskMeLoadingState extends AskMeState {}

final class AskMeErrorState extends AskMeState {
  final String error;
  AskMeErrorState({required this.error});
}

final class QuestionState extends AskMeState {
  final List<Question> allQuestions;
  final Question currentQuestion;
  final int questionIndex;
  final int total;
  final int remainingTime;

  QuestionState({
    required this.allQuestions,
    required this.currentQuestion,
    required this.questionIndex,
    required this.total,
    required this.remainingTime,
  });
}

// final class AnswerResultState extends QuestionState {
//   AnswerResultState({
//     required List<Question> allQuestions,
//     required Question currentQuestion,
//     required int questionIndex,
//     required int total,
//     required int remainingTime,
//   }) : super(
//           allQuestions: allQuestions,
//           currentQuestion: currentQuestion,
//           questionIndex: questionIndex,
//           total: total,
//           remainingTime: remainingTime,
//         );
// }

final class TimerState extends AskMeState{
  final int remainingTime;

  TimerState({required this.remainingTime});
}

final class QuestionsComplete extends AskMeState {
  final int score;
  final int total;

  QuestionsComplete({required this.score, required this.total});
}
