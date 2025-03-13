// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      id: (json['id'] as num).toInt(),
      roleName: json['role_name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      modifiedAt: DateTime.parse(json['modified_at'] as String),
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'id': instance.id,
      'role_name': instance.roleName,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'modified_at': instance.modifiedAt.toIso8601String(),
    };
