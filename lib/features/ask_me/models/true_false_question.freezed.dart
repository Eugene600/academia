// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'true_false_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrueFalseQuestion {
  @JsonKey(name: 'Question')
  String get question;
  @JsonKey(name: 'Answer')
  String get correctAnswer;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get choices;

  /// Create a copy of TrueFalseQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrueFalseQuestionCopyWith<TrueFalseQuestion> get copyWith =>
      _$TrueFalseQuestionCopyWithImpl<TrueFalseQuestion>(
          this as TrueFalseQuestion, _$identity);

  /// Serializes this TrueFalseQuestion to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrueFalseQuestion &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            const DeepCollectionEquality().equals(other.choices, choices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question, correctAnswer,
      const DeepCollectionEquality().hash(choices));

  @override
  String toString() {
    return 'TrueFalseQuestion(question: $question, correctAnswer: $correctAnswer, choices: $choices)';
  }
}

/// @nodoc
abstract mixin class $TrueFalseQuestionCopyWith<$Res> {
  factory $TrueFalseQuestionCopyWith(
          TrueFalseQuestion value, $Res Function(TrueFalseQuestion) _then) =
      _$TrueFalseQuestionCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'Question') String question,
      @JsonKey(name: 'Answer') String correctAnswer,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<String> choices});
}

/// @nodoc
class _$TrueFalseQuestionCopyWithImpl<$Res>
    implements $TrueFalseQuestionCopyWith<$Res> {
  _$TrueFalseQuestionCopyWithImpl(this._self, this._then);

  final TrueFalseQuestion _self;
  final $Res Function(TrueFalseQuestion) _then;

  /// Create a copy of TrueFalseQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? correctAnswer = null,
    Object? choices = null,
  }) {
    return _then(_self.copyWith(
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _self.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _self.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TrueFalseQuestion implements TrueFalseQuestion {
  const _TrueFalseQuestion(
      {@JsonKey(name: 'Question') required this.question,
      @JsonKey(name: 'Answer') required this.correctAnswer,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<String> choices = const ['True', 'False']})
      : _choices = choices;
  factory _TrueFalseQuestion.fromJson(Map<String, dynamic> json) =>
      _$TrueFalseQuestionFromJson(json);

  @override
  @JsonKey(name: 'Question')
  final String question;
  @override
  @JsonKey(name: 'Answer')
  final String correctAnswer;
  final List<String> _choices;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  /// Create a copy of TrueFalseQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrueFalseQuestionCopyWith<_TrueFalseQuestion> get copyWith =>
      __$TrueFalseQuestionCopyWithImpl<_TrueFalseQuestion>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrueFalseQuestionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrueFalseQuestion &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question, correctAnswer,
      const DeepCollectionEquality().hash(_choices));

  @override
  String toString() {
    return 'TrueFalseQuestion(question: $question, correctAnswer: $correctAnswer, choices: $choices)';
  }
}

/// @nodoc
abstract mixin class _$TrueFalseQuestionCopyWith<$Res>
    implements $TrueFalseQuestionCopyWith<$Res> {
  factory _$TrueFalseQuestionCopyWith(
          _TrueFalseQuestion value, $Res Function(_TrueFalseQuestion) _then) =
      __$TrueFalseQuestionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Question') String question,
      @JsonKey(name: 'Answer') String correctAnswer,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<String> choices});
}

/// @nodoc
class __$TrueFalseQuestionCopyWithImpl<$Res>
    implements _$TrueFalseQuestionCopyWith<$Res> {
  __$TrueFalseQuestionCopyWithImpl(this._self, this._then);

  final _TrueFalseQuestion _self;
  final $Res Function(_TrueFalseQuestion) _then;

  /// Create a copy of TrueFalseQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? question = null,
    Object? correctAnswer = null,
    Object? choices = null,
  }) {
    return _then(_TrueFalseQuestion(
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _self.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _self._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
