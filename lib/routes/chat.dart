import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";

import "../widgets/chat_avatar.dart";
import "../widgets/icon_button.dart";
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
class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          title: Text("Message $index"),
        ),
        childCount: 100,
      ),
    );
  }
}

/// Виджет для [ChatRoute], отображающий поле для ввода текста сообщения.
class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
  });

  void onAttachTap() {}

  void onSendTap() {}

  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
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
                  const ChatMessages(),
                ],
              ),
            ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }
}
