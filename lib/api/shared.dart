import "package:dio/dio.dart";
import "package:json_annotation/json_annotation.dart";

part "shared.g.dart";

/// Ответ для API-методов [authLogin] либо [authRegister], возвращающийся при успешной авторизации или регистрации пользователя.
@JsonSerializable()
class SuccessLoginResponse {
  /// Уникальный UUID пользователя.
  final String id;

  /// Имя пользователя.
  final String username;

  /// JWT-токен, который будет использоваться для авторизации пользователя в системе.
  final String token;

  const SuccessLoginResponse({
    required this.id,
    required this.username,
    required this.token,
  });

  factory SuccessLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$SuccessLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessLoginResponseToJson(this);
}

/// Класс, расширяющий [DioException], олицетворяющий ошибку API.
class APIException extends DioException {
  /// HTTP-код ошибки.
  final int? status;

  /// Код ошибки API.
  final String? errorCode;

  @override
  String toString() => "API error $errorCode ($status): $message";

  APIException({
    this.status,
    this.errorCode,
    super.message,
    required super.requestOptions,
  });
}
