import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "role_name")
  final String roleName; // Reflects "role_name" in the JSON.
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "modified_at")
  final DateTime modifiedAt;

  UserRole({
    required this.id,
    required this.roleName,
    required this.description,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
