// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_choice_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MultipleChoiceQuestion _$MultipleChoiceQuestionFromJson(
        Map<String, dynamic> json) =>
    _MultipleChoiceQuestion(
      question: json['question'] as String,
      choices: (json['multiple_choice'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswer: json['correct_answer'] as String,
    );

Map<String, dynamic> _$MultipleChoiceQuestionToJson(
        _MultipleChoiceQuestion instance) =>
    <String, dynamic>{
      'question': instance.question,
      'multiple_choice': instance.choices,
      'correct_answer': instance.correctAnswer,
    };
