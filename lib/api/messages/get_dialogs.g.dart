// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_dialogs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesGetDialogsResponse _$MessagesGetDialogsResponseFromJson(
        Map<String, dynamic> json) =>
    MessagesGetDialogsResponse(
      count: (json['count'] as num).toInt(),
      dialogs: (json['dialogs'] as List<dynamic>)
          .map((e) => APIChatResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessagesGetDialogsResponseToJson(
        MessagesGetDialogsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'dialogs': instance.dialogs,
    };
