import "package:dio/dio.dart";

import "../../main.dart";
import "../shared.dart";

/// Делает API-запрос, узнающий информацию по пользователю с указанным [username].
///
/// API: `users.get`.
Future<APIUserResponse> usersGet(
  String username, {
  CancelToken? cancelToken,
}) async {
  final response = await dio.post(
    "users.get",
    data: {
      "username": username,
    },
    cancelToken: cancelToken,
  );

  return APIUserResponse.fromJson(response.data);
}
