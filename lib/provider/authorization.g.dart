// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authorizationHash() => r'd92e5877c8de16b55ed3ea6e70447b3fab8d52e5';

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
///
/// Copied from [Authorization].
@ProviderFor(Authorization)
final authorizationProvider = NotifierProvider<Authorization, User?>.internal(
  Authorization.new,
  name: r'authorizationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authorizationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Authorization = Notifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
