// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCheckResponse _$AuthCheckResponseFromJson(Map<String, dynamic> json) =>
    AuthCheckResponse(
      exists: json['user-exists'] as bool,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$AuthCheckResponseToJson(AuthCheckResponse instance) =>
    <String, dynamic>{
      'user-exists': instance.exists,
      'username': instance.username,
    };
