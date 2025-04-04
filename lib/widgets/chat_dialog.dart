import "package:flutter/material.dart";

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
                  text: lastMessage!,
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

/// Виджет для [ChatDialog], отображающую аватарку чата.
class ChatAvatar extends StatelessWidget {
  /// Ширина и высота аватарки.
  static const double size = 50;

  /// Список из цветов, используемых для градиента аватарки диалога.
  static const List<Color> colors = [
    Color(0xFF1FDB5F),
    Color(0xFF31C764),
    Color(0xFFF66700),
    Color(0xFFED3900),
    Color(0xFF00ACF6),
    Color(0xFF006DED),
    // Кастомные градиенты:
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFF673AB7),
    Color(0xFFE91E63),
    Color(0xFFF44336),
    Color(0xFF2196F3),
    Color(0xFF3F51B5),
  ];

  /// Уникальный цифровой индекс этого диалога.
  ///
  /// Используется для определения цвета аватарки диалога.
  final int index;

  /// Имя пользователя, которому принадлежит этот диалог.
  ///
  /// Первая буква имени пользователя отображается в центре аватарки.
  final String? username;

  const ChatAvatar({
    super.key,
    required this.index,
    this.username,
  });

  /// Возвращает [LinearGradient] для аватарки диалога, в зависимости от переданного [index].
  static LinearGradient getGradient(int index) {
    final int colorIndex = (index * 2) % colors.length;

    return LinearGradient(
      colors: [
        colors[colorIndex],
        colors[colorIndex + 1],
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstChar =
        username?.isNotEmpty == true ? username![0].toUpperCase() : null;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: getGradient(index),
        ),
        child: firstChar != null
            ? Center(
                child: Text(
                  firstChar,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
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
