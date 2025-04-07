import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../api/messages/send.dart";
import "../provider/authorization.dart";
import "../provider/chats.dart";
import "../widgets/chat_avatar.dart";
import "../widgets/icon_button.dart";
import "../widgets/message_bubble.dart";
import "../widgets/svg_icon.dart";

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
          ChatAvatar(
            index: 0,
            username: username,
          ),
          const Gap(12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Text(
                "В сети",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5E7A90),
                ),
              ),
            ],
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
class ChatMessages extends ConsumerWidget {
  /// Username пользователя, с которым открыт чат.
  final String username;

  const ChatMessages({
    super.key,
    required this.username,
  });

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

    final count = chat.messages.length;

    return SliverList.separated(
      itemCount: count,
      separatorBuilder: (BuildContext context, int index) {
        return const Gap(12);
      },
      itemBuilder: (BuildContext context, int index) {
        final invertedIndex = count - index - 1;
        final message = chat.messages[invertedIndex];
        final isSenderCurrent = message.senderID == auth.id;

        return Align(
          alignment:
              isSenderCurrent ? Alignment.centerRight : Alignment.centerLeft,
          child: MessageBubble(
            text: message.text,
            isSenderCurrent: isSenderCurrent,
            bubbleType: BubbleType.values[index % BubbleType.values.length],
            isLastInGroup: (index + 1) % 3 == 0,
            isRead: isSenderCurrent ? true : null,
            sentTime: message.sendTime,
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
              decoration: const InputDecoration(
                hintText: "Сообщение",
              ),
              minLines: 1,
              maxLines: 5,
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
class ChatRoute extends StatelessWidget {
  static const String routePath = "/chat/:username";

  /// Username пользователя, с которым открыт чат.
  final String username;

  const ChatRoute({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
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
