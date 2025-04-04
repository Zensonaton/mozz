// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessLoginResponse _$SuccessLoginResponseFromJson(
        Map<String, dynamic> json) =>
    SuccessLoginResponse(
      id: json['id'] as String,
      username: json['username'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$SuccessLoginResponseToJson(
        SuccessLoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'token': instance.token,
    };
