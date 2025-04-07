import "package:flutter/material.dart";
import "package:gap/gap.dart";

import "../utils.dart";
import "svg_icon.dart";

/// Тип для "пузыря" ([MessageBubble]).
///
/// Пузыри имеют скругление, которое зависит от того, в какой позиции (рядом с другими) пузырями оно находится:
/// - [top] - пузырь вверху.
/// - [connected] - пузырь соединён с другими пузырями.
/// - [bottom] - пузырь внизу.
///
/// Пытаясь отобразить, это выглядит так:
/// - [connected].
/// - [top], [connected], ..., [connected], [bottom].
enum BubbleType {
  /// Пузырь вверху.
  top,

  /// Пузырь соединён с другими пузырями, либо является единственным.
  connected,

  /// Пузырь внизу.
  bottom,
}

/// [CustomPainter] для [MessageBubble].
class MessageBubblePainter extends CustomPainter {
  /// Размер скругления пузыря для "неактивной" части пузыря (т.е., полностью скруглённая).
  static const Radius cornerRadius = Radius.circular(23);

  /// Размер скругления у "соединённой" части пузыря (т.е., не полностью скруглённая).
  static const Radius connectedRadius = Radius.circular(6);

  /// Указывает, что сообщение отправлено текущим пользователем.
  final bool isSenderCurrent;

  /// Указывает тип пузыря. Для более подробной информации см. [BubbleType].
  final BubbleType bubbleType;

  /// Указывает, что это сообщение находится последним в "группе" из сообщений, и у такого сообщения будет небольшой "хвостик".
  final bool isLastInGroup;

  const MessageBubblePainter({
    required this.isSenderCurrent,
    required this.bubbleType,
    required this.isLastInGroup,
  });

  /// Возвращает скругление для верхнего угла.
  static Radius getTopRadius(BubbleType type) {
    switch (type) {
      case BubbleType.top:
        return cornerRadius;
      case BubbleType.connected:
      case BubbleType.bottom:
        return connectedRadius;
    }
  }

  /// Возвращает скругление для нижнего угла.
  static Radius getBottomRadius(BubbleType type) {
    switch (type) {
      case BubbleType.top:
      case BubbleType.connected:
        return connectedRadius;
      case BubbleType.bottom:
        return cornerRadius;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final color = isSenderCurrent
        ? MessageBubble.meSenderColor
        : MessageBubble.otherSenderColor;

    final paint = Paint()..color = color;
    final path = Path();

    final topRadius = getTopRadius(bubbleType);
    final bottomRadius =
        isLastInGroup ? const Radius.circular(0) : getBottomRadius(bubbleType);

    path.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: isSenderCurrent ? cornerRadius : topRadius,
        topRight: isSenderCurrent ? topRadius : cornerRadius,
        bottomRight: isSenderCurrent ? bottomRadius : cornerRadius,
        bottomLeft: isSenderCurrent ? cornerRadius : bottomRadius,
      ),
    );

    // Если это последнее сообщение в группе, добавляем "хвостик" внизу.
    if (isLastInGroup) {
      final trailPath = Path();

      if (isSenderCurrent) {
        trailPath
          ..moveTo(size.width, size.height - MessageBubble.trailHeight)
          ..lineTo(size.width + MessageBubble.trailWidth, size.height)
          ..lineTo(size.width, size.height)
          ..close();
      } else {
        trailPath
          ..moveTo(0, size.height - MessageBubble.trailHeight)
          ..lineTo(-MessageBubble.trailWidth, size.height)
          ..lineTo(0, size.height)
          ..close();
      }
      // TODO: Сделать скругление для "хвостика".

      path.addPath(trailPath, Offset.zero);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Виджет, отображающий "пузырь" сообщения в чате. Используется в [ChatDialog] для отображения сообщений.
class MessageBubble extends StatelessWidget {
  /// Цвет фона пузыря сообщения, если сообщение отправлено текущим пользователем.
  static const Color meSenderColor = Color(0xFF3CED78);

  /// Цвет фона пузыря сообщения, если сообщение отправлено собеседником.
  static const Color otherSenderColor = Color(0xFFEDF2F6);

  /// Цвет текста, иконок и прочего внутри пузыря сообщения, если сообщение отправлено текущим пользователем.
  static const Color meSenderTextColor = Color(0xFF00521C);

  /// Цвет текста, иконок и прочего внутри пузыря сообщения, если сообщение отправлено собеседником.
  static const Color otherSenderTextColor = Color(0xFF2B333E);

  /// Высота у "хвостика" внизу пузыря.
  static const double trailHeight = 21;

  /// Ширина у "хвостика" внизу пузыря.
  static const double trailWidth = 10;

  /// Текст сообщения.
  final String text;

  /// Указывает, что сообщение отправлено текущим пользователем.
  final bool isSenderCurrent;

  /// Указывает тип пузыря. Для более подробной информации см. [BubbleType].
  final BubbleType bubbleType;

  /// Указывает, что это сообщение находится последним в "группе" из сообщений, и у такого сообщения будет небольшой "хвостик".
  final bool isLastInGroup;

  /// Время отправки сообщения.
  final DateTime sentTime;

  /// Указывает, было ли прочитано это сообщение. Если null, то никакая из иконок не отображается.
  final bool? isRead;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isSenderCurrent,
    required this.bubbleType,
    required this.isLastInGroup,
    required this.sentTime,
    this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSenderCurrent ? meSenderTextColor : otherSenderTextColor;

    return Padding(
      padding: EdgeInsets.only(
        left: isSenderCurrent ? 0 : trailWidth,
        right: isSenderCurrent ? trailWidth : 0,
      ),
      child: CustomPaint(
        painter: MessageBubblePainter(
          isSenderCurrent: isSenderCurrent,
          bubbleType: bubbleType,
          isLastInGroup: isLastInGroup,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
              const Gap(12),
              Text(
                formatTime(sentTime),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
              if (isRead != null) ...[
                const Gap(4),
                SvgIcon(
                  name: isRead! ? "read" : "unread",
                  size: 12,
                  color: color,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
