import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../provider/authorization.dart";

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
    final user = ref.read(authorizationProvider)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello, @${user.username}",
            ),
            const Gap(12),
            FilledButton(
              onPressed: () {
                ref.read(authorizationProvider.notifier).logout();
              },
              child: const Text(
                "Logout",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
