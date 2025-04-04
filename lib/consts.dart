/// URL для локального API.
///
/// Вероятнее всего, вам нужен [baseAPIUrl] вместо этого значения.
const String localBaseAPIUrl = "http://localhost:8000/api/";

/// Базовый URL для API, который может извлекаться из значения `--dart-define BASE_API_URL=http://google.com/` при сборке приложения, либо использовать локальное значение [localBaseAPIUrl] как fallback.
String baseAPIUrl = const String.fromEnvironment(
  "API_URL",
  defaultValue: localBaseAPIUrl,
);

/// Regex, проверяющий валидность username'а пользователя.
///
/// Имя пользователя может быть длиною от 3 до 18 символов, включая английские и русские.
RegExp usernameRegex = RegExp(r"^[a-zA-Z_а-яА-Я]{3,18}$");
