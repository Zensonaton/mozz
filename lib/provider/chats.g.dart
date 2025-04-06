// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatsHash() => r'0d080218097b9d87380f6a5375bdc41a9893d157';

/// [Provider], предоставляющий доступ к списку всех чатов текущего пользователя.
///
/// Copied from [Chats].
@ProviderFor(Chats)
final chatsProvider = NotifierProvider<Chats, List<APIChatResponse>>.internal(
  Chats.new,
  name: r'chatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Chats = Notifier<List<APIChatResponse>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
