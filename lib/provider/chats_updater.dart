import "dart:async";
import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:json_annotation/json_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:ws/ws.dart";

import "../api/shared.dart";
import "../consts.dart";
import "../utils.dart";
import "chats.dart";

part "chats_updater.g.dart";

/// [Provider] для [ChatsUpdater].
@Riverpod(keepAlive: true)
ChatsUpdater chatsUpdater(Ref ref) => ChatsUpdater(ref);

/// Сервис, который обновляет сообщения в фоне.
///
/// Для получения этого сервиса используйте [chatsUpdaterProvider].
class ChatsUpdater {
  final Ref ref;

  ChatsUpdater(this.ref);

  /// Возвращает URL для подключения к WebSocket-серверу.
  static String get url =>
      "${baseAPIUrl.replaceAll("http", "ws")}messages.events";

  /// Объект типа [WebSocketClient], который сохранён лишь после вызова [start].
  WebSocketClient? _client;

  /// Список из [StreamSubscription] для отслеживания состояния подключения к WebSocket-серверу.
  final List<StreamSubscription> _subscriptions = [];

  /// Запускает обновление сообщений, если оно не было запущено ранее.
  void start(String token) async {
    if (_client != null) return;

    final client = WebSocketClient(
      WebSocketOptions.vm(
        connectionRetryInterval: (
          min: const Duration(milliseconds: 500),
          max: const Duration(seconds: 15),
        ),
        headers: {
          "Token": token,
        },
      ),
    );
    await client.connect(url);

    _subscriptions.addAll([
      client.stateChanges.listen(onStateChange),
      client.stream.listen(onUpdate),
    ]);
    _client = client;
  }

  /// Останавливает обновление сообщений.
  void stop() {
    if (_client == null) return;

    _client?.close();
    _client = null;

    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Обработчик изменений состояния подключения WebSocket-сервера ([WebSocketClient.stateChanges]).
  void onStateChange(WebSocketClientState state) {
    print("WS client state: $state");
  }

  /// Обработчик событий с WebSocket-сервера ([WebSocketClient.stream]).
  void onUpdate(Object message) {
    final update = jsonDecode(message as String) as Map<String, dynamic>;
    final type = update["type"];
    final data = update["data"];

    switch (type) {
      case "newmsg":
        onNewMessage(NewMessageUpdate.fromJson(data));

        return;
    }

    throw Exception("Unknown update type: $type");
  }

  /// Обработчик событий новых сообщений.
  void onNewMessage(NewMessageUpdate update) {
    print("New message: ${update.text}");

    final chats = ref.read(chatsProvider);
    final chatsNotifier = ref.read(chatsProvider.notifier);
    final message = APIMessage(
      id: update.id,
      senderID: update.sender,
      text: update.text,
      sendTime: update.timestamp,
    );

    // Если чат не существует, то добавляем его.
    if (!chats.any((chat) => chat.id == update.dialog)) {
      chatsNotifier.updateChat(
        APIChatResponse(
          id: update.dialog,
          users: update.users,
          messages: [message],
        ),
      );

      return;
    }

    chatsNotifier.updateMessage(update.dialog, message);
  }
}

/// Класс, репрезентирующий ответ от WebSocket-сервера, который отображает событие нового сообщения.
@JsonSerializable()
class NewMessageUpdate {
  /// ID сообщения.
  final int id;

  /// ID диалога, в котором было отправлено сообщение.
  final String dialog;

  /// Список из пользователей этого диалога.
  @JsonKey(name: "dialog_users")
  final List<APIUserResponse> users;

  /// Содержимое сообщения.
  final String text;

  /// Время отправки сообщения.
  @JsonKey(fromJson: dateTimefromUnix, toJson: dateTimeToUnix)
  final DateTime timestamp;

  /// ID пользователя, отправившего сообщение.
  final String sender;

  /// true, если это сообщение было отправлено текущим пользователем.
  @JsonKey(name: "from_self")
  final bool fromSelf;

  NewMessageUpdate({
    required this.id,
    required this.dialog,
    required this.users,
    required this.text,
    required this.timestamp,
    required this.sender,
    required this.fromSelf,
  });

  factory NewMessageUpdate.fromJson(Map<String, dynamic> json) =>
      _$NewMessageUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$NewMessageUpdateToJson(this);
}
