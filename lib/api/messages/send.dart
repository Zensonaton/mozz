import "package:json_annotation/json_annotation.dart";

import "../../main.dart";

part "send.g.dart";

/// Ответ для [messagesSend].
@JsonSerializable()
class MessagesSendResponse {
  /// ID отправленного сообщения.
  final int id;

  /// ID чата, в котором было отправлено это сообщение.
  @JsonKey(name: "dialog-id")
  final String dialogID;

  const MessagesSendResponse({
    required this.id,
    required this.dialogID,
  });

  factory MessagesSendResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesSendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesSendResponseToJson(this);
}

/// Делает API-запрос, отправляющий сообщение пользователю с указанным [username] с указанным [text].
///
/// API: `messages.send`.
Future<MessagesSendResponse> messagesSend(String username, String text) async {
  final response = await dio.post(
    "messages.send",
    data: {
      "username": username,
      "text": text,
    },
  );

  return MessagesSendResponse.fromJson(response.data);
}
