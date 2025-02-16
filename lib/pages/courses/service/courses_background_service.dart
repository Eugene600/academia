import 'package:academia/exports/barrel.dart';
import 'package:academia/models/core/course/course.dart';

class CoursesBackgroundService {
  static final CoursesBackgroundService _instance =
      CoursesBackgroundService._internal();

  factory CoursesBackgroundService() {
    return _instance;
  }

  /// Private named constructor that prevents external instantiation.
  CoursesBackgroundService._internal();

  void notifyTodaysCourses() {
    CourseModelHelper().queryAll().then((value) {
      int coursestoday = 0;
      value.map((e) {
        final course = Course.fromJson(e);
        if (course.dayOfWeek == DateTime.now().weekdayToString()) {
          coursestoday++;
        }
      });
    });
  }
}
