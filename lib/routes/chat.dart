import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../api/messages/send.dart";
import "../api/shared.dart";
import "../provider/authorization.dart";
import "../provider/chats.dart";
import "../widgets/chat_avatar.dart";
import "../widgets/history_divider.dart";
import "../widgets/icon_button.dart";
import "../widgets/message_bubble.dart";
import "../widgets/svg_icon.dart";

/// Базовый тип, который является аналогом для [APIMessage], который используется для отображения (рендеринга) сообщений в чате.
///
/// Данный класс дальше расширяется до [_Message] (обычное сообщение), либо [_HistoryDivider].
class _MessageBase {
  /// Дата этого сообщения.
  final DateTime date;

  _MessageBase({
    required this.date,
  });
}

/// Изменённая версия класса [APIMessage], которая используется для отображения сообщений в чате.
class _Message extends _MessageBase {
  final String text;
  final bool isSenderCurrent;
  BubbleType bubbleType;
  bool isLastInGroup;
  final bool? isRead;

  _Message({
    required this.text,
    required this.isSenderCurrent,
    required this.bubbleType,
    required this.isLastInGroup,
    required this.isRead,
    required super.date,
  });
}

/// Тип, который используется для отображения разделителя в истории сообщений.
class _HistoryDivider extends _MessageBase {
  _HistoryDivider({
    required super.date,
  });
}

/// [SliverPersistentHeaderDelegate], используемый для создания шапки [SliverPersistentHeader] в [ChatRoute].
class _ChatAppBarDelegate extends SliverPersistentHeaderDelegate {
  /// Имя пользователя, с которым открыт чат.
  final String username;

  _ChatAppBarDelegate({
    required this.username,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEDF2F6),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const SvgIcon(
              name: "back",
              color: Color(0xFF2B333E),
            ),
            onPressed: () => context.pop(),
          ),
          const Gap(6),
          Flexible(
            child: ChatAvatar(
              index: 0,
              username: username,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  "В сети",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5E7A90),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 66.0;

  @override
  double get minExtent => 66.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/// Виджет для [ChatRoute], отображающий список сообщений.
class ChatMessages extends HookConsumerWidget {
  /// Username пользователя, с которым открыт чат.
  final String username;

  const ChatMessages({
    super.key,
    required this.username,
  });

  /// Преобразовывает список из [APIMessage] в список [_Message] либо [_HistoryDivider].
  List<_MessageBase> _parseMessages(List<APIMessage> messages, String ownerID) {
    final List<_MessageBase> parsed = [];

    // Не забываем, что API возвращает сообщения в обратном порядке.
    // Поэтому мы проходимся по ним с конца, чтобы отобразить их в правильном порядке.

    DateTime? lastDate;

    for (int i = messages.length - 1; i >= 0; i--) {
      final msg = messages[i];
      final msgSender = msg.senderID;
      final isCurrent = msgSender == ownerID;

      final prevMsg = messages.elementAtOrNull(i + 1);
      final nextMsg = i == 0 ? null : messages.elementAtOrNull(i - 1);
      final isFirstInGroup = prevMsg?.senderID != msgSender;
      final isLastInGroup = nextMsg?.senderID != msgSender;

      // Разделители истории сообщений по дням.
      lastDate ??= msg.sendTime;
      if (msg.sendTime.day != lastDate.day) {
        parsed.insert(
          0,
          _HistoryDivider(
            date: msg.sendTime,
          ),
        );
        lastDate = msg.sendTime;
      }

      // Тип "пузырька" сообщения.
      BubbleType bubbleType = BubbleType.connected;
      if (isFirstInGroup && isLastInGroup) {
        bubbleType = BubbleType.single;
      } else if (isFirstInGroup) {
        bubbleType = BubbleType.top;
      } else if (isLastInGroup) {
        bubbleType = BubbleType.bottom;
      }

      parsed.insert(
        0,
        _Message(
          text: msg.text,
          isSenderCurrent: isCurrent,
          bubbleType: bubbleType,
          isLastInGroup: isLastInGroup,
          isRead: isCurrent ? true : null,
          date: msg.sendTime,
        ),
      );
    }

    return parsed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider(username));
    if (chat == null) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.all(
            20,
          ),
          child: Center(
            child: Text(
              "Тут тихо.\n\nНе боись, скажи «привет»!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF2B333E),
              ),
            ),
          ),
        ),
      );
    }

    final auth = ref.read(authorizationProvider)!;

    final parsedMessages = useMemoized(
      () => _parseMessages(chat.messages, auth.id),
      [chat.messages],
    );

    final count = parsedMessages.length;

    return SliverList.separated(
      itemCount: count,
      separatorBuilder: (BuildContext context, int index) {
        return const Gap(12);
      },
      itemBuilder: (BuildContext context, int index) {
        final invertedIndex = count - index - 1;
        final message = parsedMessages[invertedIndex];

        if (message is _HistoryDivider) {
          return HistoryDivider(
            date: message.date,
          );
        } else if (message is! _Message) {
          throw Exception("Unknown message type: ${message.runtimeType}");
        }

        return Align(
          alignment: message.isSenderCurrent
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: MessageBubble(
            text: message.text,
            isSenderCurrent: message.isSenderCurrent,
            bubbleType: message.bubbleType,
            isLastInGroup: message.isLastInGroup,
            isRead: message.isRead,
            sentTime: message.date,
          ),
        );
      },
    );
  }
}

/// Виджет для [ChatRoute], отображающий поле для ввода текста сообщения.
class ChatInput extends HookWidget {
  /// Username пользователя, с которым открыт чат.
  final String username;

  const ChatInput({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void onAttachTap() {}

    void onSendTap() async {
      final text = controller.text.trim();
      controller.clear();

      if (text.isEmpty) return;

      await messagesSend(username, text);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEDF2F6),
          ),
        ),
      ),
      child: Row(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconButton(
            icon: const SvgIcon(
              name: "attach",
              color: Color(0xFF2B333E),
            ),
            onPressed: onAttachTap,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Сообщение",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          CustomIconButton(
            icon: const SvgIcon(
              name: "send",
              color: Color(0xFF2B333E),
            ),
            onPressed: onSendTap,
          ),
        ],
      ),
    );
  }
}

/// Route, отображающий отдельный чат с пользователем.
///
/// go_route: `/chat/:username` ([routePath]).
class ChatRoute extends HookConsumerWidget {
  static const String routePath = "/chat/:username";

  /// Username пользователя, с которым открыт чат.
  final String username;

  const ChatRoute({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider(username));

    final controller = useScrollController();

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.jumpTo(controller.position.maxScrollExtent);
        });

        return null;
      },
      [],
    );

    useEffect(
      () {
        if (chat == null) return null;
        if (!controller.hasClients) return null;
        if (controller.position.pixels != controller.position.maxScrollExtent) {
          return null;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.animateTo(
            controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        });
        HapticFeedback.vibrate();

        return null;
      },
      [chat?.messages],
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _ChatAppBarDelegate(
                      username: username,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    sliver: ChatMessages(
                      username: username,
                    ),
                  ),
                ],
              ),
            ),
            ChatInput(
              username: username,
            ),
          ],
        ),
      ),
    );
  }
}
