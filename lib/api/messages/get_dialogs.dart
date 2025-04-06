import "package:json_annotation/json_annotation.dart";

import "../../main.dart";
import "../shared.dart";

part "get_dialogs.g.dart";

/// Ответ для [messagesGetDialogs].
@JsonSerializable()
class MessagesGetDialogsResponse {
  /// Общее количество диалогов.
  final int count;

  /// Список из диалогов.
  final List<APIChatResponse> dialogs;

  const MessagesGetDialogsResponse({
    required this.count,
    required this.dialogs,
  });

  factory MessagesGetDialogsResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesGetDialogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesGetDialogsResponseToJson(this);
}

/// Делает API-запрос, получающий список диалогов пользователя.
///
/// API: `messages.get_dialogs`.
Future<MessagesGetDialogsResponse> messagesGetDialogs() async {
  final response = await dio.post("messages.get_dialogs");

  return MessagesGetDialogsResponse.fromJson(response.data);
}
