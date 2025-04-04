import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app.dart";
import "consts.dart";
import "dio_interceptors.dart";

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

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}
