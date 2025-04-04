import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gap/gap.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../api/auth/login.dart";
import "../../api/shared.dart";
import "../../provider/authorization.dart";
import "../../utils.dart";
import "../../widgets/loading_button.dart";
import "../../widgets/svg_icon.dart";

/// Route, используемый как продолжение для [AuthRoute], который предлагает пользователю ввести пароль от уже имеющегося аккаунта.
///
/// go_route: `/auth/login` ([routePath]).
class AuthLoginRoute extends HookConsumerWidget {
  static const String routePath = "login";

  /// Настоящий username пользователя, который был передан в [AuthRoute].
  final String username;

  const AuthLoginRoute({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    final hidden = useState(true);

    void onHideTap() {
      hidden.value = !hidden.value;
    }

    return Scaffold(
      floatingActionButton: LoadingFloatingActionButton(
        onPressed: () async {
          late final SuccessLoginResponse response;
          try {
            response = await authLogin(username, controller.text);
          } on APIException catch (error) {
            if (!context.mounted) return;
            showAPIExceptionDialog(context, error);

            return;
          }

          ref
              .read(authorizationProvider.notifier)
              .loginViaAPIResponse(response);

          // Ничего не делаем, редирект произойдёт автоматически.
        },
        child: const Icon(
          Icons.arrow_forward,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: [
                    const TextSpan(
                      text: "Привет,\n",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: "@$username!",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(4),
              TextField(
                controller: controller,
                obscureText: hidden.value,
                decoration: InputDecoration(
                  hintText: "Пароль",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 6,
                    ),
                    child: SvgIcon(
                      name: "shield",
                      color: Color(0xFF9DB7CB),
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 6,
                      right: 12,
                    ),
                    child: IconButton(
                      onPressed: onHideTap,
                      icon: SizedBox(
                        height: 24,
                        width: 24,
                        child: SvgIcon(
                          name: hidden.value ? "view" : "not_view",
                          color: const Color(0xFF9DB7CB),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
