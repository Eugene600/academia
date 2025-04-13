import 'package:academia/features/ask_me/models/question.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'true_false_question.freezed.dart';
part 'true_false_question.g.dart';

@freezed
abstract class TrueFalseQuestion with _$TrueFalseQuestion implements Question {
  const factory TrueFalseQuestion({
    @JsonKey(name: 'Question') required String question,
    @JsonKey(name: 'Answer') required String correctAnswer,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(['True', 'False']) List<String> choices,
  }) = _TrueFalseQuestion;

  factory TrueFalseQuestion.fromJson(Map<String, dynamic> json) =>
      _$TrueFalseQuestionFromJson(json);
}

