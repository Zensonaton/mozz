import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../consts.dart";
import "../dio_interceptors.dart";

part "dio.g.dart";

/// [Provider] для [Dio], используемый для создания API-запросов.
///
/// Пример использования:
/// ```dart
/// final response = await dio.get("https://google.com");
/// print(response.data);
/// ```
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      validateStatus: (_) => true,
      baseUrl: baseAPIUrl,
    ),
  )..interceptors.add(
      DioInterceptor(ref),
    );
}
