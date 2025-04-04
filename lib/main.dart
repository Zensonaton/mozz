import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

import "app.dart";
import "consts.dart";
import "dio_interceptors.dart";
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
final Dio dio = Dio(
  BaseOptions(
    validateStatus: (_) => true,
    baseUrl: baseAPIUrl,
  ),
)..interceptors.add(
    DioInterceptor(),
  );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const MainApp(),
    ),
  );
}
