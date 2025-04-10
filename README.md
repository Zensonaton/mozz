# Небольшой мессенджер на Flutter

[Видео-демонстрация](https://www.youtube.com/watch?v=rGUjJ_oVB9E).

Тестовый проект. Задачи:

- Экран со списком чатов.
- Экран с сообщениями чата.

## Содержание репозитория

**Приложение**: Flutter (Dart), Riverpod, flutter_hooks, Dio, go_router.

**Backend**: FastAPI (Python), asyncio, CouchDB.

## Запуск приложения

> [!NOTE]
> Поскольку backend на момент написания этого README не опубликован, запуск приложения возможен лишь с использованием удалённого сервера.
>
> В случае, если запущен локальный сервер, то указывать `--dart-define API_URL=...` необязательно.

```shell
flutter pub get
flutter run --dart-define API_URL=http://server.zensonaton.work:6786/api/
```
