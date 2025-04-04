import "package:dio/dio.dart";

import "api/shared.dart";

/// [Interceptor] для [Dio], обрабатывающий ответы от API.
class DioInterceptor extends Interceptor {
  DioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Добавляем access token.

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data as Map<String, dynamic>;
    final error = data["error"];

    // Проверяем на наличие ошибок.
    if (error != null) {
      throw APIException(
        status: error["status"],
        errorCode: error["error"],
        message: error["message"],
        requestOptions: response.requestOptions,
      );
    }

    super.onResponse(response, handler);
  }
}
