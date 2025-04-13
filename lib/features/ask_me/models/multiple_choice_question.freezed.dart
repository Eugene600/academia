// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multiple_choice_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MultipleChoiceQuestion {
  String get question;
  @JsonKey(name: 'multiple_choice')
  List<String> get choices;
  @JsonKey(name: 'correct_answer')
  String get correctAnswer;

  /// Create a copy of MultipleChoiceQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MultipleChoiceQuestionCopyWith<MultipleChoiceQuestion> get copyWith =>
      _$MultipleChoiceQuestionCopyWithImpl<MultipleChoiceQuestion>(
          this as MultipleChoiceQuestion, _$identity);

  /// Serializes this MultipleChoiceQuestion to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MultipleChoiceQuestion &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other.choices, choices) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question,
      const DeepCollectionEquality().hash(choices), correctAnswer);

  @override
  String toString() {
    return 'MultipleChoiceQuestion(question: $question, choices: $choices, correctAnswer: $correctAnswer)';
  }
}

/// @nodoc
abstract mixin class $MultipleChoiceQuestionCopyWith<$Res> {
  factory $MultipleChoiceQuestionCopyWith(MultipleChoiceQuestion value,
          $Res Function(MultipleChoiceQuestion) _then) =
      _$MultipleChoiceQuestionCopyWithImpl;
  @useResult
  $Res call(
      {String question,
      @JsonKey(name: 'multiple_choice') List<String> choices,
      @JsonKey(name: 'correct_answer') String correctAnswer});
}

/// @nodoc
class _$MultipleChoiceQuestionCopyWithImpl<$Res>
    implements $MultipleChoiceQuestionCopyWith<$Res> {
  _$MultipleChoiceQuestionCopyWithImpl(this._self, this._then);

  final MultipleChoiceQuestion _self;
  final $Res Function(MultipleChoiceQuestion) _then;

  /// Create a copy of MultipleChoiceQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? choices = null,
    Object? correctAnswer = null,
  }) {
    return _then(_self.copyWith(
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _self.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _self.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MultipleChoiceQuestion implements MultipleChoiceQuestion {
  const _MultipleChoiceQuestion(
      {required this.question,
      @JsonKey(name: 'multiple_choice') required final List<String> choices,
      @JsonKey(name: 'correct_answer') required this.correctAnswer})
      : _choices = choices;
  factory _MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) =>
      _$MultipleChoiceQuestionFromJson(json);

  @override
  final String question;
  final List<String> _choices;
  @override
  @JsonKey(name: 'multiple_choice')
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  @JsonKey(name: 'correct_answer')
  final String correctAnswer;

  /// Create a copy of MultipleChoiceQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MultipleChoiceQuestionCopyWith<_MultipleChoiceQuestion> get copyWith =>
      __$MultipleChoiceQuestionCopyWithImpl<_MultipleChoiceQuestion>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MultipleChoiceQuestionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MultipleChoiceQuestion &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question,
      const DeepCollectionEquality().hash(_choices), correctAnswer);

  @override
  String toString() {
    return 'MultipleChoiceQuestion(question: $question, choices: $choices, correctAnswer: $correctAnswer)';
  }
}

/// @nodoc
abstract mixin class _$MultipleChoiceQuestionCopyWith<$Res>
    implements $MultipleChoiceQuestionCopyWith<$Res> {
  factory _$MultipleChoiceQuestionCopyWith(_MultipleChoiceQuestion value,
          $Res Function(_MultipleChoiceQuestion) _then) =
      __$MultipleChoiceQuestionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String question,
      @JsonKey(name: 'multiple_choice') List<String> choices,
      @JsonKey(name: 'correct_answer') String correctAnswer});
}

/// @nodoc
class __$MultipleChoiceQuestionCopyWithImpl<$Res>
    implements _$MultipleChoiceQuestionCopyWith<$Res> {
  __$MultipleChoiceQuestionCopyWithImpl(this._self, this._then);

  final _MultipleChoiceQuestion _self;
  final $Res Function(_MultipleChoiceQuestion) _then;

  /// Create a copy of MultipleChoiceQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? question = null,
    Object? choices = null,
    Object? correctAnswer = null,
  }) {
    return _then(_MultipleChoiceQuestion(
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _self._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _self.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
