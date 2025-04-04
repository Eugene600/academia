import 'package:academia/database/database.dart';
import 'package:academia/features/exam_timetable/repository/exam_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

part 'exam_state.dart';
part 'exam_event.dart';

final class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final Logger _logger = Logger();
  final ExamRepository _examRepository = ExamRepository();
  final List<ExamModelData> _exams = [];
  final List<ExamModelData> _fetchedExams = [];

  ExamBloc() : super(ExamStateLoading()) {
    _logger.i("Exam block initialized!");

    on<FetchCachedExams>((event, emit) async {
      emit(ExamStateLoading());
      final res = await _examRepository.fetchCachedExams();
      res.fold((error) {
        emit(ExamStateError(error: error));
      }, (exams) {
        print(exams);
        _exams.addAll(exams);
        emit(ExamStateLoaded(userExams: _exams, fetchedExams: []));
      });
    });

    on<FetchExamsEvent>((event, emit) async {
      emit(ExamStateLoading());
      final res = await _examRepository.fetchExams(event.courses);

      _fetchedExams.clear();
      return res.fold((error) {
        emit(ExamStateError(error: error));
      }, (exams) {
        if (event.autoAdd) {
          _examRepository.clearAllCachedExams();
          for (final exam in exams) {
            add(RemoveExamFromCache(exam: exam));
            add(AddExamToCache(exam: exam));
            _exams.removeWhere((e) => e.courseCode == exam.courseCode);
          }
          _exams.addAll(exams);
        }
        _fetchedExams.addAll(exams);
        emit(ExamStateLoaded(userExams: _exams, fetchedExams: _fetchedExams));
      });
    });

    on<AddExamToCache>((event, emit) async {
      final res = await _examRepository.addExamToCache(event.exam);

      return res.fold((error) {
        emit(ExamStateError(error: error));
      }, (exam) {
        _exams.removeWhere((e) => e.courseCode == event.exam.courseCode);
        _exams.add(event.exam);
        emit(ExamStateLoaded(userExams: _exams, fetchedExams: _fetchedExams));
      });
    });

    on<RemoveExamFromCache>((event, emit) async {
      final res = await _examRepository.removeExamFromCache(event.exam);

      return res.fold((error) {
        emit(ExamStateError(error: error));
      }, (exams) {
        _exams.removeWhere((e) => e.courseCode == event.exam.courseCode);
        emit(ExamStateLoaded(userExams: _exams, fetchedExams: _fetchedExams));
      });
    });
  }
}
