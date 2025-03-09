import 'package:academia/database/database.dart';
import 'package:academia/features/courses/repository/course_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository _courseRepository = CourseRepository();
  final Logger _logger = Logger();
  CourseCubit() : super(CourseStateInitial()) {
    fetchAllCachedCourses();
  }

  Future<void> saveCourse(CourseData course) async {
    emit(CourseStateLoading());
    _logger.i("Attempting to save user course to cache");
    final courses = await _courseRepository.saveCourseToCache(course);
    courses.fold((error) {
      _logger.e(error);
      emit(CourseStateError(error: error));
    }, (courses) {
      _logger.i("Course saved successfully");
      fetchAllCachedCourses();
    });
  }

  Future<void> fetchAllCachedCourses() async {
    emit(CourseStateLoading());
    _logger.i("Attempting to retrieve user courses from local cache");
    final courses = await _courseRepository.fetchAllCachedCourses();
    courses.fold((error) {
      _logger.e(error);
      emit(CourseStateError(error: error));
    }, (courses) {
      _logger.i("Courses fetched successfully");
      emit(CourseStateLoaded(courses: courses));
    });
  }

  Future<void> refreshCourses() async {
    emit(CourseStateLoading());
    _logger.i("Attempting to retrieve user courses from magnet");
    final courses = await _courseRepository.syncCoursesWithMagnet();
    courses.fold((error) {
      _logger.e(error);
      emit(CourseStateError(error: error));
    }, (courses) {
      _logger.i("Courses fetched successfully");
      emit(CourseStateLoaded(courses: courses));
    });
  }
}
