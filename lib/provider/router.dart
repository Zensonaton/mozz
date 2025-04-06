import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../main.dart";
import "../routes/auth.dart";
import "../routes/auth/login.dart";
import "../routes/auth/register.dart";
import "../routes/chat.dart";
import "../routes/home.dart";
import "authorization.dart";

part "router.g.dart";

/// [GoRouter], используемый для навигации по приложению.
///
/// Если Вам нужно изменить redirect'ы, то обратитесь к [currentAuthStateProvider].
@riverpod
GoRouter router(Ref ref) {
  final authorizedNotifier =
      ValueNotifier(ref.read(authorizationProvider) != null);
  ref
    ..onDispose(authorizedNotifier.dispose)
    ..listen(authorizationProvider, (_, value) {
      authorizedNotifier.value = value != null;
    });

  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: authorizedNotifier,
    initialLocation: AuthRoute.routePath,
    navigatorKey: navigatorKey,
    redirect: (_, GoRouterState state) {
      final isAuthorized = authorizedNotifier.value;
      final isInLoginRoute =
          state.fullPath?.startsWith(AuthRoute.routePath) ?? false;

      if (isAuthorized && isInLoginRoute) {
        return HomeRoute.routePath;
      } else if (!isAuthorized && !isInLoginRoute) {
        return AuthRoute.routePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AuthRoute.routePath,
        builder: (_, __) => const AuthRoute(),
        routes: [
          GoRoute(
            path: AuthLoginRoute.routePath,
            builder: (_, state) {
              return AuthLoginRoute(username: state.extra! as String);
            },
          ),
          GoRoute(
            path: AuthRegisterRoute.routePath,
            builder: (_, state) {
              return AuthRegisterRoute(username: state.extra! as String);
            },
          ),
        ],
      ),
      GoRoute(
        path: HomeRoute.routePath,
        builder: (_, __) => const HomeRoute(),
      ),
      GoRoute(
        path: ChatRoute.routePath,
        builder: (_, state) => ChatRoute(
          username: state.pathParameters["username"]!,
        ),
      ),
    ],
  );
}
