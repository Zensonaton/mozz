import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "provider/router.dart";

/// Основной виджет приложения.
class MainApp extends ConsumerWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: "Messenger",
      theme: ThemeData(
        fontFamily: "Gilroy",
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF2B333E),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Color(0xFF9DB7CB),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          fillColor: const Color(0xFFEDF2F6),
          filled: true,
          prefixIconColor: const Color(0xFF9DB7CB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final platform in TargetPlatform.values)
              platform: const FadeForwardsPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
