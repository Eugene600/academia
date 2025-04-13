// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'true_false_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrueFalseQuestion _$TrueFalseQuestionFromJson(Map<String, dynamic> json) =>
    _TrueFalseQuestion(
      question: json['Question'] as String,
      correctAnswer: json['Answer'] as String,
    );

Map<String, dynamic> _$TrueFalseQuestionToJson(_TrueFalseQuestion instance) =>
    <String, dynamic>{
      'Question': instance.question,
      'Answer': instance.correctAnswer,
    };
