import "package:flutter/material.dart";

import "api/shared.dart";
import "consts.dart";

/// Показывает диалоговое окно типа [AlertDialog].
Future<void> showAlertDialog(
  BuildContext context, {
  String? title,
  String? message,
  String? buttonText,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title != null ? Text(title) : null,
      content: message != null ? Text(message) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText ?? "OK"),
        ),
      ],
    ),
  );
}

/// Показывает диалоговое окно типа [AlertDialog] при передче исключения [APIException].
Future<void> showAPIExceptionDialog(
  BuildContext context,
  APIException exception, {
  String? title,
}) async {
  await showAlertDialog(
    context,
    title: title ?? "Ошибка",
    message: exception.message,
  );
}

/// Возвращает true, если [username] является валидным именем пользователя.
bool isValidUsername(String username) => usernameRegex.hasMatch(username);
