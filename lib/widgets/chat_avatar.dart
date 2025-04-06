import "package:flutter/material.dart";
import "package:skeletonizer/skeletonizer.dart";

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
                child: Skeleton.ignore(
                  child: Text(
                    firstChar,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
