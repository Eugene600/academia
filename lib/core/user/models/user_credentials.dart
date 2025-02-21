import 'package:drift/drift.dart';
import './user.dart';

class UserCredential extends Table {
  @JsonKey("user_id")
  TextColumn get userId => text().references(User, #id).nullable()();
  @JsonKey("admission_number")
  TextColumn get admno => text().nullable()();
  @JsonKey("access_token")
  TextColumn get accessToken => text().nullable()();

  @JsonKey("username")
  TextColumn get username => text().nullable().references(User, #username)();
  @JsonKey("email")
  TextColumn get email => text().nullable().references(User, #email)();
  @JsonKey("password")
  TextColumn get password => text()();
  @JsonKey("last_login")
  DateTimeColumn get lastLogin => dateTime().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {userId};
}
