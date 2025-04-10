import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api/messages/get_dialogs.dart";
import "../api/shared.dart";

part "chats.g.dart";

/// [Provider], предоставляющий доступ к списку всех чатов текущего пользователя.
@Riverpod(keepAlive: true)
class Chats extends _$Chats {
  @override
  List<APIChatResponse>? build() {
    _getChats();
    return null;
  }

  /// Внутренний метод, получающий список чатов текущего пользователя через API.
  Future<void> _getChats() async {
    final response = await messagesGetDialogs();

    state = response.dialogs;
  }

  /// Добавляет чат [chat] в список уже существующих чатов. Если чат уже существует, то информация будет обновлена.
  void updateChat(APIChatResponse chat) {
    state ??= [];

    final index = state!.indexWhere(
      (c) => c.id == chat.id,
    );

    // Чат не найден, просто добавляем его.
    if (index == -1) {
      state = [chat, ...state!];

      return;
    }

    final oldChat = state![index];
    List<APIMessage> messages = [...oldChat.messages];

    for (final message in chat.messages) {
      if (messages.any((m) => m.id == message.id)) continue;

      messages.insert(0, message);
    }

    final newChat = oldChat.copyWith(
      users: chat.users,
      messages: messages,
    );

    state = [
      ...state!.sublist(0, index),
      newChat,
      ...state!.sublist(index + 1),
    ];
  }

  /// Добавляет сообщение [APIMessage] (либо обновляет) в чат с ID [chatId].
  void updateMessage(String chatId, APIMessage message) {
    state ??= [];

    final index = state!.indexWhere(
      (c) => c.id == chatId,
    );

    if (index == -1) return;

    final chat = state![index];
    final messages = [...chat.messages];

    final messageIndex = messages.indexWhere(
      (m) => m.id == message.id,
    );

    if (messageIndex == -1) {
      messages.insert(0, message);
    } else {
      messages[messageIndex] = message;
    }

    state = [
      ...state!.sublist(0, index),
      chat.copyWith(messages: messages),
      ...state!.sublist(index + 1),
    ];
  }
}

/// [Provider], предоставляющий доступ к чату с определённым [username].
@riverpod
APIChatResponse? chat(Ref ref, String username) {
  final chats = ref.watch(chatsProvider);

  try {
    return chats?.firstWhere(
      (c) => c.users.last.username == username,
    );
  } catch (_) {
    return null;
  }
}
