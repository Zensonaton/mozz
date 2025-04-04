import "dart:ui";

import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../widgets/chat_dialog.dart";
import "../widgets/svg_icon.dart";

/// [SliverPersistentHeaderDelegate], используемый для создания шапки [SliverPersistentHeader] в [HomeRoute].
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
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
                      ),
                    ),
                    const Gap(4),
                    TextFormField(
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

/// Route, отображающий главный экран приложения после авторизации: в нём показан список диалогов.
///
/// go_route: `/` ([routePath]).
class HomeRoute extends ConsumerWidget {
  static const String routePath = "/";

  const HomeRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final useMinimizedLayout = width < 250;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _SliverHeaderDelegate(),
            ),
            SliverList.separated(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                final isEven = index % 2 == 0;

                return ChatDialog(
                  index: index,
                  username: isEven ? "Виктор" : "Саша",
                  lastMessage: isEven ? "Уже сделал?" : "Я готов",
                  isSenderCurrent: isEven,
                  sentTimeText: useMinimizedLayout
                      ? null
                      : (isEven ? "Вчера" : "2 минуты назад"),
                  onTap: () {},
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  indent: 20,
                  endIndent: 20,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
