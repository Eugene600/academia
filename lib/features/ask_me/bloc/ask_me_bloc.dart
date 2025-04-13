import 'dart:async';

import 'package:academia/features/ask_me/models/multiple_choice_question.dart';
import 'package:academia/features/ask_me/models/question.dart';
import 'package:academia/features/ask_me/models/true_false_question.dart';
import 'package:academia/features/ask_me/repository/ask_me_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'ask_me_event.dart';
part 'ask_me_state.dart';

class AskMeBloc extends Bloc<AskMeEvent, AskMeState> {
  final AskMeRepository repository = AskMeRepository();
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _timeLimit = 0;
  int _remainingSeconds = 0;

  Timer? _timer;

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  AskMeBloc() : super(AskMeInitialState()) {
    on<GenerateQuestions>((event, emit) async {
      emit(AskMeLoadingState());
      _cancelTimer();

      final result = event.multiChoice
          ? await repository.fetchQuestions<MultipleChoiceQuestion>(
              event.file,
              event.title,
              event.userId,
              event.multiChoice,
              (json) => MultipleChoiceQuestion.fromJson(json))
          : await repository.fetchQuestions<TrueFalseQuestion>(
              event.file,
              event.title,
              event.userId,
              event.multiChoice,
              (json) => TrueFalseQuestion.fromJson(json));

      result.fold(
        (error) => emit(AskMeErrorState(error: error)),
        (questions) {
          _questions = questions;
          _currentIndex = 0;
          _score = 0;
          _timeLimit = event.timeLimit;
          _remainingSeconds = _timeLimit * 60;

          emit(QuestionInProgress(
            allQuestions: _questions,
            currentQuestion: _questions.first,
            questionIndex: _currentIndex,
            score: _score,
            total: _questions.length,
            timeLimit: event.timeLimit,
            remainingSeconds: _remainingSeconds,
          ));
          add(StartTimer());
        },
      );
    });

    on<StartTimer>((event, emit) {
      _cancelTimer();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          add(TimerTick(remainingTime: _remainingSeconds));
        } else {
          _cancelTimer();
          add(TimerComplete());
        }
      });
    });

    on<TimerTick>((event, emit) {
      if (state is QuestionInProgress) {
        final currentState = state as QuestionInProgress;
        emit(QuestionInProgress(
            allQuestions: currentState.allQuestions,
            currentQuestion: currentState.currentQuestion,
            questionIndex: currentState.questionIndex,
            score: currentState.score,
            total: currentState.total,
            timeLimit: currentState.timeLimit,
            remainingSeconds: currentState.remainingSeconds));
      }
    });

    on<TimerComplete>((event, emit) {
      _cancelTimer();
      emit(QuestionsComplete(score: _score, total: _questions.length));
    });

    on<SubmitAnswer>((event, emit) {
      final currentQuestion = _questions[_currentIndex];

      final isCorrect = currentQuestion.correctAnswer == event.answer;

      if (isCorrect) _score++;

      _currentIndex++;

      if (_currentIndex >= _questions.length) {
        emit(QuestionsComplete(score: _score, total: _questions.length));
      } else {
        emit(QuestionInProgress(
          allQuestions: _questions,
          currentQuestion: currentQuestion,
          questionIndex: _currentIndex,
          score: _score,
          total: _questions.length,
          timeLimit: _timeLimit,
          remainingSeconds: _remainingSeconds,
        ));
      }
    });

    on<CompleteQuestions>((event, emit) {
      _cancelTimer();
      emit(AskMeInitialState());
    });
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
