import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api/shared.dart";

part "chats.g.dart";

/// [Provider], предоставляющий доступ к списку всех чатов текущего пользователя.
@Riverpod(keepAlive: true)
class Chats extends _$Chats {
  @override
  List<APIChatResponse> build() {
    return [];
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
