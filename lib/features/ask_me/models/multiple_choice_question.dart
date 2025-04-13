import 'package:academia/features/ask_me/models/question.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'multiple_choice_question.freezed.dart';
part 'multiple_choice_question.g.dart';

@freezed
abstract class MultipleChoiceQuestion with _$MultipleChoiceQuestion implements Question {
  const factory MultipleChoiceQuestion({
    required String question,
    @JsonKey(name: 'multiple_choice') required List<String> choices,
    @JsonKey(name: 'correct_answer') required String correctAnswer,
  }) = _MultipleChoiceQuestion;

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) =>
      _$MultipleChoiceQuestionFromJson(json);
}
