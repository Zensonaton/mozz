import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

import "app.dart";
import "provider/dio.dart";
import "provider/shared_preferences.dart";

/// Глобальный ключ навигации приложения.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Объект [Dio], используемый для создания API-запросов.
///
/// Пример использования:
/// ```dart
/// final response = await dio.get("https://google.com");
/// print(response.data);
/// ```
late final Dio dio;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(
        await SharedPreferences.getInstance(),
      ),
    ],
  );

  dio = container.read(dioProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}
