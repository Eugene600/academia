part of 'ask_me_bloc.dart';

sealed class AskMeEvent {}

class GenerateQuestions extends AskMeEvent {
  final File file;
  final String title;
  final String userId;
  final bool multiChoice;
  final int timeLimit;

  GenerateQuestions({
    required this.file,
    required this.title,
    required this.userId,
    required this.multiChoice,
    required this.timeLimit,
  });
}

class SubmitAnswer extends AskMeEvent {
  final String answer;

  SubmitAnswer({required this.answer});
}

class NextQuestion extends AskMeEvent{}

class StartTimer extends AskMeEvent{}

class TimerTick extends AskMeEvent {
  final int remainingTime;

  TimerTick({required this.remainingTime});
}

class TimerComplete extends AskMeEvent{}

class SelectOption extends AskMeEvent {
  final int selectedIndex;

  SelectOption({required this.selectedIndex});
}


class CompleteQuestions extends AskMeEvent {}
