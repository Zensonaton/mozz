import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "api/shared.dart";
import "provider/authorization.dart";

/// [Interceptor] для [Dio], обрабатывающий ответы от API.
class DioInterceptor extends Interceptor {
  final Ref ref;

  DioInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(authorizationProvider)?.token;
    if (token != null) {
      options.headers["Token"] = token;
    }

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
