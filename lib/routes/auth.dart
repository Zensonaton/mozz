import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";

import "../api/auth/check.dart";
import "../api/shared.dart";
import "../utils.dart";
import "../widgets/loading_button.dart";
import "../widgets/svg_icon.dart";

/// Route, используемый для авторизации пользователя.
///
/// go_route: `/auth` ([routePath]).
class AuthRoute extends HookWidget {
  static const String routePath = "/auth";

  const AuthRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final controller = useTextEditingController();

    return Scaffold(
      floatingActionButton: LoadingFloatingActionButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) return;

          late final AuthCheckResponse response;
          try {
            response = await authCheck(controller.text);
          } on APIException catch (error) {
            if (context.mounted) {
              showAPIExceptionDialog(context, error);
            }

            return;
          }

          if (!context.mounted) return;

          context.push(
            response.exists ? "./login" : "./register",
            extra: response.username ?? controller.text,
          );
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
                const Text(
                  "Вход",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                TextFormField(
                  controller: controller,
                  validator: (String? contents) {
                    if (contents == null || contents.isEmpty) {
                      return "Введите имя пользователя";
                    }

                    if (!isValidUsername(contents)) {
                      return "Невалидное имя пользователя";
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Имя пользователя",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 6,
                      ),
                      child: SvgIcon(
                        name: "person",
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
