import "dart:ui";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../api/shared.dart";
import "../api/users/get.dart";
import "../provider/authorization.dart";
import "../provider/chats.dart";
import "../utils.dart";
import "../widgets/chat_dialog.dart";
import "../widgets/svg_icon.dart";

/// [SliverPersistentHeaderDelegate], используемый для создания шапки [SliverPersistentHeader] в [HomeRoute].
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// [TextEditingController], используемый для поиска чатов.
  final TextEditingController controller;

  const _SliverHeaderDelegate({
    required this.controller,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          color: Colors.white.withValues(alpha: 0.85),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Чаты",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B333E),
                      ),
                    ),
                    const Gap(4),
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Поиск",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                            right: 6,
                          ),
                          child: SvgIcon(
                            name: "search",
                            color: Color(0xFF9DB7CB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 134.0;

  @override
  double get minExtent => 134.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/// Виджет для [DialogsView], отображающий сообщение о том, что чатов нет.
class NoChats extends StatelessWidget {
  const NoChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF2B333E),
              ),
              children: [
                TextSpan(
                  text: "Добро пожаловать в Мессенджер!\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "Введите ",
                ),
                TextSpan(
                  text: "@ИмяПользователя ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "в поиске, чтобы начать общение.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Виджет для [DialogsView], отображающий список чатов пользователя.
class ChatList extends HookConsumerWidget {
  /// [Duration], после которого будет выполнен поиск чатов.
  static const Duration searchDelay = Duration(milliseconds: 800);

  /// [TextEditingController], используемый для поиска чатов.
  final TextEditingController controller;

  const ChatList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerID = ref.read(authorizationProvider)!.id;
    final chats = ref.watch(chatsProvider);

    final isLoading = useState(false);
    final cancelToken = useRef<CancelToken?>(null);
    final foundUser = useState<APIUserResponse?>(null);

    useValueListenable(controller);
    final debouncedText = useDebounced(controller.text.trim(), searchDelay);

    void onChatTap(String username) {
      context.push("/chat/$username");
    }

    Future<void> search(String query) async {
      if (query.isEmpty) return;

      isLoading.value = true;
      cancelToken.value = CancelToken();

      try {
        final response = await usersGet(query, cancelToken: cancelToken.value);

        if (context.mounted) {
          foundUser.value = response;
        }
      } catch (_) {
        // No-op.
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(
      () {
        foundUser.value = null;
        isLoading.value = true;

        if (cancelToken.value != null) {
          cancelToken.value!.cancel("Request cancelled");
          cancelToken.value = null;
        }

        if (controller.text.trim().isEmpty) {
          isLoading.value = false;
        }

        return null;
      },
      [controller.text],
    );

    useEffect(
      () {
        if (debouncedText != null && debouncedText.isNotEmpty) {
          search(debouncedText);
        } else {
          isLoading.value = false;
        }

        return null;
      },
      [debouncedText],
    );

    final useMinimizedLayout = MediaQuery.sizeOf(context).width < 250;

    final hasSearchItem = isLoading.value || foundUser.value != null;
    final chatItemsCount = chats.length + (hasSearchItem ? 1 : 0);

    // Если ничего нету, то отображаем сообщение о том, что чатов нет.
    if (chatItemsCount == 0) {
      return const NoChats();
    }

    return SliverList.separated(
      itemCount: chatItemsCount,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // Производится поиск, отображаем skeleton loader.
          if (isLoading.value) {
            return Skeletonizer(
              child: ChatDialog.fake(
                minimized: true,
              ),
            );
          }

          // Пользователь найден, отображаем его.
          final user = foundUser.value;
          if (user != null) {
            final isSameUser = user.id == ownerID;

            return ChatDialog(
              index: index,
              username: user.username,
              onTap: isSameUser ? null : () => onChatTap(user.username),
            );
          }
        }

        if (hasSearchItem) index--;

        final chat = chats[index];

        // В моём API, в любом чате находится два пользователя: владелец аккаунта и собеседник.
        // Поэтому, .first - владелец аккаунта (т.е., это мы), а .last - собеседник.
        final user = chat.users.last;

        // "Последнее" сообщение находится в начале списка.
        final lastMessage = chat.messages.first;

        return ChatDialog(
          index: index,
          username: user.username,
          lastMessage: lastMessage.text,
          isSenderCurrent: lastMessage.senderID == ownerID,
          sentTimeText:
              useMinimizedLayout ? null : formatDateTime(DateTime.now()),
          onTap: () => onChatTap(user.username),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          indent: 20,
          endIndent: 20,
        );
      },
    );
  }
}

/// Route, отображающий главный экран приложения после авторизации: в нём показан список диалогов.
///
/// go_route: `/` ([routePath]).
class HomeRoute extends HookWidget {
  static const String routePath = "/";

  const HomeRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _SliverHeaderDelegate(
                controller: controller,
              ),
            ),
            ChatList(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
