import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gap/gap.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../api/auth/register.dart";
import "../../api/shared.dart";
import "../../provider/authorization.dart";
import "../../utils.dart";
import "../../widgets/loading_button.dart";
import "../../widgets/svg_icon.dart";

/// Route, используемый как продолжение для [AuthRoute], который продолжает регистрацию аккаунта (путём ввода пароля).
///
/// go_route: `/auth/register` ([routePath]).
class AuthRegisterRoute extends HookConsumerWidget {
  static const String routePath = "register";

  /// Настоящий username пользователя, который был передан в [AuthRoute].
  final String username;

  const AuthRegisterRoute({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final password1 = useTextEditingController();
    final password2 = useTextEditingController();

    return Scaffold(
      floatingActionButton: LoadingFloatingActionButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) return;

          late final SuccessLoginResponse response;
          try {
            response = await authRegister(username, password1.text);
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
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B333E),
                    ),
                    children: [
                      const TextSpan(
                        text: "Познакомимся,\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "@$username?",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(4),
                TextFormField(
                  controller: password1,
                  decoration: const InputDecoration(
                    hintText: "Пароль",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 6,
                      ),
                      child: SvgIcon(
                        name: "shield",
                        color: Color(0xFF9DB7CB),
                      ),
                    ),
                  ),
                ),
                const Gap(2),
                TextFormField(
                  controller: password2,
                  validator: (String? contents) {
                    if (contents == null || contents.trim().isEmpty) {
                      return "Введите пароль повторно";
                    }

                    if (contents != password1.text) {
                      return "Пароли не совпадают";
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Повтор пароля",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 6,
                      ),
                      child: SvgIcon(
                        name: "shield",
                        color: Color(0xFF9DB7CB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
