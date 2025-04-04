import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "shared_preferences.g.dart";

/// [Provider], возвращающий объект [SharedPreferences].
@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  // Данный Provider override'ится в другом месте.

  throw UnimplementedError("Not implemented");
}
