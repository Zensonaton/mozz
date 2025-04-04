import "package:json_annotation/json_annotation.dart";

import "../../main.dart";

part "check.g.dart";

/// Ответ для [authCheck].
@JsonSerializable()
class AuthCheckResponse {
  /// Указывает, существует ли этот пользователь в системе или нет.
  @JsonKey(name: "user-exists")
  final bool exists;

  /// Имя пользователя, с которым был выполнен запрос. Данное поле может слегка отличаться от того, которое было передано в запросе, поскольку в нем могут быть удалены пробелы и другие символы, а так же изменен регистр.
  final String? username;

  const AuthCheckResponse({
    required this.exists,
    this.username,
  });

  factory AuthCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCheckResponseToJson(this);
}

/// Делает API-запрос, проверяющий то, зарегистрирован ли пользователь с указанным [username] или нет.
///
/// В зависимости от результата, пользователю стоит либо зарегистрироваться, либо войти в систему.
///
/// API: `auth.check`.
Future<AuthCheckResponse> authCheck(String username) async {
  final response = await dio.post(
    "auth.check",
    data: {
      "username": username,
    },
  );

  return AuthCheckResponse.fromJson(response.data);
}
