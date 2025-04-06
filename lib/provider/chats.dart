import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api/messages/get_dialogs.dart";
import "../api/shared.dart";

part "chats.g.dart";

/// [Provider], предоставляющий доступ к списку всех чатов текущего пользователя.
@Riverpod(keepAlive: true)
class Chats extends _$Chats {
  @override
  List<APIChatResponse> build() {
    _getChats();
    return [];
  }

  /// Внутренний метод, получающий список чатов текущего пользователя через API.
  Future<void> _getChats() async {
    final response = await messagesGetDialogs();

    state = response.dialogs;
  }

  /// Добавляет новый чат в список чатов текущего пользователя.
  void addChat(APIChatResponse chat) {
    state = [chat, ...state];
  }

  /// Удаляет чат из списка чатов текущего пользователя.
  void removeChat(APIChatResponse chat) {
    state = state
        .where(
          (c) => c.id != chat.id,
        )
        .toList();
  }
}

/// [Provider], предоставляющий доступ к чату с определённым [username].
@riverpod
APIChatResponse? chat(Ref ref, String username) {
  final chats = ref.watch(chatsProvider);

  try {
    return chats.firstWhere(
      (c) => c.users.last.username == username,
    );
  } catch (_) {
    return null;
  }
}
