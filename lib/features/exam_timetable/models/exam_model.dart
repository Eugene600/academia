import 'package:drift/drift.dart';

class ExamModel extends Table {
  @JsonKey("course_code")
  TextColumn get courseCode => text()();
  @JsonKey("datetime_str")
  DateTimeColumn get examDate => dateTime()();
  TextColumn get venue => text()();
  TextColumn get campus => text()(); // Nullable field
  @JsonKey("hrs")
  TextColumn get hours => text()();
  TextColumn get invigilator => text().nullable()(); // Nullable field

  @override
  Set<Column<Object>>? get primaryKey => {courseCode};
}
