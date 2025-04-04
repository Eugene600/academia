part of 'exam_bloc.dart';

@immutable
sealed class ExamEvent {}

final class FetchCachedExams extends ExamEvent {}

final class FetchExamsEvent extends ExamEvent {
  final bool autoAdd;
  final List<String> courses;
  FetchExamsEvent({required this.courses, this.autoAdd = false});
}

final class AddExamToCache extends ExamEvent {
  final ExamModelData exam;
  AddExamToCache({required this.exam});
}

final class RemoveExamFromCache extends ExamEvent {
  final ExamModelData exam;
  RemoveExamFromCache({required this.exam});
}
