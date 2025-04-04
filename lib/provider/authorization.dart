import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api/shared.dart";
import "shared_preferences.dart";

part "authorization.g.dart";

/// Класс, используемый внутри [authorizationProvider], репрезентирующий авторизованного пользователя.
class User {
  /// Уникальный ID пользователя.
  final String id;

  /// Имя пользователя.
  ///
  /// Под именем пользователя подразумевается то, что находится послё @: `@username` -> `username`.
  final String username;

  /// Access-токен пользователя.
  final String token;

  User({
    required this.id,
    required this.username,
    required this.token,
  });
}

/// [Provider] для хранения состояния авторизации пользователя. Позволяет авторизовывать и деавторизовывать пользователя.
///
/// Для получения доступа к этому [Provider] используйте [authorizationProvider]:
/// ```dart
/// final User? user = ref.read(authorizationProvider);
/// if (user != null) {
///   // Пользователь авторизован, можно использовать его данные:
///   print(user.username);
/// } else {
///   // Пользователь не авторизован, можно показать экран авторизации.
/// }
/// ```
///
/// Для авторизации необходимо использовать метод [login], с передачей сопутствующих параметров.
@Riverpod(keepAlive: true)
class Authorization extends _$Authorization {
  @override
  User? build() {
    final prefs = ref.read(sharedPrefsProvider);
    final id = prefs.getString("ID");
    final username = prefs.getString("Username");
    final token = prefs.getString("Token");
    if (id != null && username != null && token != null) {
      state = User(id: id, username: username, token: token);

      return state;
    }

    return null;
  }

  /// {@template Authorization.login}
  /// Авторизовывает пользователя, который ранее смог успешно авторизоваться по логину и паролю (API [authLogin]), либо зарегистрировался (API [authRegister]), получив access-токен.
  /// {@endtemplate}
  Future<void> login(String id, String username, String token) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString("ID", id);
    await prefs.setString("Username", username);
    await prefs.setString("Token", token);

    state = User(id: id, username: username, token: token);
  }

  /// Аналог метода [login], но принимает в качестве параметра [SuccessLoginResponse] - ответ от API, который содержит в себе данные для авторизации.
  ///
  /// {@macro Authorization.login}
  Future<void> loginViaAPIResponse(SuccessLoginResponse response) async {
    return await login(
      response.id,
      response.username,
      response.token,
    );
  }

  /// Деавторизовывает пользователя.
  Future<void> logout() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.clear();

    state = null;
  }
}
