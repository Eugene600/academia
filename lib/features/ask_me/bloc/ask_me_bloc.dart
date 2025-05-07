import 'dart:async';
import 'dart:io';

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

          emit(QuestionState(
            allQuestions: _questions,
            currentQuestion: _questions.first,
            questionIndex: _currentIndex,
            total: _questions.length,
            remainingTime: _remainingSeconds,
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
      if (state is QuestionState) {
        final current = state as QuestionState;

        emit(QuestionState(
          allQuestions: current.allQuestions,
          currentQuestion: current.currentQuestion,
          questionIndex: current.questionIndex,
          total: current.total,
          remainingTime: event.remainingTime,
        ));
      }
    });

    on<TimerComplete>((event, emit) {
      _cancelTimer();
      emit(QuestionsComplete(
          score: _score, total: _questions.length)); // to be removed later
    });

    on<SubmitAnswer>((event, emit) {
      final currentQuestion = _questions[_currentIndex];

      final isCorrect = currentQuestion.correctAnswer == event.answer;

      if (isCorrect) _score++;
    });

    on<NextQuestion>((event, emit) {
      if (_currentIndex >= _questions.length) {
        emit(QuestionsComplete(score: _score, total: _questions.length));
      }

      _currentIndex++;
      final nextQuestion = _questions[_currentIndex];

      emit(QuestionState(
        allQuestions: _questions,
        currentQuestion: nextQuestion,
        questionIndex: _currentIndex,
        total: _questions.length,
        remainingTime: _remainingSeconds,
      ));
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
