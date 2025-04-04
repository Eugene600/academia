import 'package:drift/drift.dart';

class ExamModel extends Table {
  @JsonKey("course_code")
  TextColumn get courseCode => text().withLength(min: 6, max: 10)();
  TextColumn get day => text().withLength(min: 10, max: 20)();
  TextColumn get time => text().withLength(min: 10, max: 20)();
  TextColumn get venue => text().withLength(min: 1, max: 100)();
  TextColumn get campus => text().nullable()(); // Nullable field
  @JsonKey("hrs")
  TextColumn get hours => text()();
  TextColumn get invigilator => text().nullable()(); // Nullable field

  @override
  Set<Column<Object>>? get primaryKey => {courseCode};
}
