// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesSendResponse _$MessagesSendResponseFromJson(
        Map<String, dynamic> json) =>
    MessagesSendResponse(
      id: (json['id'] as num).toInt(),
      dialogID: json['dialog-id'] as String,
    );

Map<String, dynamic> _$MessagesSendResponseToJson(
        MessagesSendResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dialog-id': instance.dialogID,
    };
