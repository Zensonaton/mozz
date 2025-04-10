import "package:dio/dio.dart";
import "package:json_annotation/json_annotation.dart";

import "../utils.dart";

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

/// Ответ для API-методов, возвращающий информацию о пользователе.
@JsonSerializable()
class APIUserResponse {
  /// Уникальный UUID пользователя.
  final String id;

  /// Имя пользователя.
  final String username;

  /// Указывает, есть ли у этого пользователя аватарка.
  final bool hasAvatar;

  /// Если [hasAvatar] правдив, то возвращает URL аватарки пользователя.
  final String? avatarUrl;

  const APIUserResponse({
    required this.id,
    required this.username,
    required this.hasAvatar,
    this.avatarUrl,
  });

  factory APIUserResponse.fromJson(Map<String, dynamic> json) =>
      _$APIUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$APIUserResponseToJson(this);
}

/// Объект API-сообщения.
@JsonSerializable()
class APIMessage {
  /// ID сообщения.
  final int id;

  /// ID пользователя, отправившего это сообщение.
  @JsonKey(name: "sender-id")
  final String senderID;

  /// Текст сообщения.
  final String text;

  /// Время отправки сообщения в формате [DateTime].
  @JsonKey(
    name: "send-time",
    fromJson: dateTimefromUnix,
    toJson: dateTimeToUnix,
  )
  final DateTime sendTime;

  APIMessage({
    required this.id,
    required this.senderID,
    required this.text,
    required this.sendTime,
  });

  APIMessage copyWith({
    int? id,
    String? senderID,
    String? text,
    DateTime? sendTime,
  }) {
    return APIMessage(
      id: id ?? this.id,
      senderID: senderID ?? this.senderID,
      text: text ?? this.text,
      sendTime: sendTime ?? this.sendTime,
    );
  }

  factory APIMessage.fromJson(Map<String, dynamic> json) =>
      _$APIMessageFromJson(json);

  Map<String, dynamic> toJson() => _$APIMessageToJson(this);
}

/// Ответ для API-методов, возвращающий информацию о чате.
@JsonSerializable()
class APIChatResponse {
  /// ID чата.
  final String id;

  /// Список из пользователей этого чата.
  final List<APIUserResponse> users;

  /// Список из сообщений этого чата.
  final List<APIMessage> messages;

  APIChatResponse({
    required this.id,
    required this.users,
    required this.messages,
  });

  APIChatResponse copyWith({
    List<APIUserResponse>? users,
    List<APIMessage>? messages,
  }) {
    return APIChatResponse(
      id: id,
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }

  factory APIChatResponse.fromJson(Map<String, dynamic> json) =>
      _$APIChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$APIChatResponseToJson(this);
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
