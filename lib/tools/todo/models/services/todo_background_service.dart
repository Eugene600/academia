import 'package:academia/exports/barrel.dart';

class TodoBackgroundService {
  static final TodoBackgroundService _instance =
      TodoBackgroundService._internal();

  factory TodoBackgroundService() {
    return _instance;
  }

  /// Private named constructor that prevents external instantiation.
  TodoBackgroundService._internal();

  void notifyPendingTasks() {
    TodoModelHelper().queryAll().then((value) {
      value.map((e) {
        final todo = Todo.fromJson(e);
      });
    });
  }
}
