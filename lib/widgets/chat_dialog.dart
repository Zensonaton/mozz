import "package:flutter/material.dart";

import "../fake_data.dart";
import "chat_avatar.dart";

/// Виджет для [ChatDialog], отображающий правый блок диалога с информацией о времени отправки последнего сообщения.
class ChatDialogLastMessageInfo extends StatelessWidget {
  /// Строка, репрезентирующая время отправки последнего сообщения, например, "Вчера", "2 минуты назад".
  final String text;

  const ChatDialogLastMessageInfo({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF5E7A90),
      ),
    );
  }
}

/// Виджет для [ChatDialog], отображающий центральный блок с информацией о диалоге.
class ChatDialogInfo extends StatelessWidget {
  /// Имя пользователя, которому принадлежит этот диалог.
  final String username;

  /// Содержимое последнего сообщения в этом диалоге.
  final String? lastMessage;

  /// Указывает, что [lastMessage] был отправлен текущим пользователем приложения.
  final bool isSenderCurrent;

  const ChatDialogInfo({
    super.key,
    required this.username,
    this.lastMessage,
    required this.isSenderCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final sanitizedMessage = lastMessage?.replaceAll("\n", " ");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          username,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        if (lastMessage != null)
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              children: [
                if (isSenderCurrent)
                  const TextSpan(
                    text: "Вы: ",
                    style: TextStyle(
                      color: Color(0xFF2B333E),
                    ),
                  ),
                TextSpan(
                  text: sanitizedMessage!,
                  style: const TextStyle(
                    color: Color(0xFF5E7A90),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Виджет, отображающий отдельный диалог в списке чатов.
class ChatDialog extends StatelessWidget {
  /// Максимальная высота этого виджета.
  static const double maxHeight = 70;

  /// "Внутренняя" высота этого виджета.
  static const double innerHeight = 50;

  /// Внутренний padding.
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: (maxHeight - innerHeight) / 2,
  );

  /// Уникальный цифровой индекс этого диалога.
  ///
  /// Используется для определения цвета аватарки диалога.
  final int index;

  /// Имя пользователя, которому принадлежит этот диалог.
  final String username;

  /// Содержимое последнего сообщения в этом диалоге.
  final String? lastMessage;

  /// Указывает, что [lastMessage] был отправлен текущим пользователем приложения.
  final bool isSenderCurrent;

  /// Строка, репрезентирующая время отправки последнего сообщения, например, "Вчера", "2 минуты назад".
  ///
  /// Если не указано, то блок с этой информацией не будет отображаться.
  final String? sentTimeText;

  /// Callback-метод, вызвающийся при нажатии на этот диалог.
  final VoidCallback? onTap;

  const ChatDialog({
    super.key,
    this.index = 0,
    required this.username,
    this.lastMessage,
    this.isSenderCurrent = false,
    this.sentTimeText,
    this.onTap,
  });

  /// Создает экземпляр [ChatDialog] с фейковыми параметрами на основе переданного [index].
  ///
  /// Используется для skeleton loader'ов.
  static ChatDialog fake({int index = 0, bool minimized = false}) {
    return ChatDialog(
      index: index,
      username: fakeUsernames[index % fakeUsernames.length],
      lastMessage: fakeMessages[index % fakeMessages.length],
      sentTimeText: minimized ? null : fakeTime[index % fakeTime.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatAvatar(
                index: index,
                username: username,
              ),
              Expanded(
                child: ChatDialogInfo(
                  username: username,
                  isSenderCurrent: isSenderCurrent,
                  lastMessage: lastMessage,
                ),
              ),
              if (sentTimeText != null)
                ChatDialogLastMessageInfo(
                  text: sentTimeText!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
