import "../../main.dart";
import "../shared.dart";

/// Делает API-запрос, авторизовывающий пользователя с указанным [username] и [password] в системе.
///
/// API: `auth.login`.
Future<SuccessLoginResponse> authLogin(String username, String password) async {
  final response = await dio.post(
    "auth.login",
    data: {
      "username": username,
      "password": password,
    },
  );

  return SuccessLoginResponse.fromJson(response.data);
}
