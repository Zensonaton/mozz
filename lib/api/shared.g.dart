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

APIUserResponse _$APIUserResponseFromJson(Map<String, dynamic> json) =>
    APIUserResponse(
      id: json['id'] as String,
      username: json['username'] as String,
      hasAvatar: json['hasAvatar'] as bool,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$APIUserResponseToJson(APIUserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'hasAvatar': instance.hasAvatar,
      'avatarUrl': instance.avatarUrl,
    };

APIMessage _$APIMessageFromJson(Map<String, dynamic> json) => APIMessage(
      id: (json['id'] as num).toInt(),
      senderID: json['sender-id'] as String,
      text: json['text'] as String,
      sendTime: dateTimefromUnix((json['send-time'] as num).toInt()),
    );

Map<String, dynamic> _$APIMessageToJson(APIMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender-id': instance.senderID,
      'text': instance.text,
      'send-time': dateTimeToUnix(instance.sendTime),
    };

APIChatResponse _$APIChatResponseFromJson(Map<String, dynamic> json) =>
    APIChatResponse(
      id: json['id'] as String,
      users: (json['users'] as List<dynamic>)
          .map((e) => APIUserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => APIMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$APIChatResponseToJson(APIChatResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'users': instance.users,
      'messages': instance.messages,
    };
