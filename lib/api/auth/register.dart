import "../../main.dart";
import "../shared.dart";

/// Делает API-запрос, регистрирующий пользователя с указанным [username] и [password].
///
/// API: `auth.register`.
Future<SuccessLoginResponse> authRegister(
  String username,
  String password,
) async {
  final response = await dio.post(
    "auth.register",
    data: {
      "username": username,
      "password": password,
    },
  );

  return SuccessLoginResponse.fromJson(response.data);
}
