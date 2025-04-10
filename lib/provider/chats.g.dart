// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatHash() => r'0ea5c1afc12913255bd256f8dab6ff6693c398f0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// [Provider], предоставляющий доступ к чату с определённым [username].
///
/// Copied from [chat].
@ProviderFor(chat)
const chatProvider = ChatFamily();

/// [Provider], предоставляющий доступ к чату с определённым [username].
///
/// Copied from [chat].
class ChatFamily extends Family<APIChatResponse?> {
  /// [Provider], предоставляющий доступ к чату с определённым [username].
  ///
  /// Copied from [chat].
  const ChatFamily();

  /// [Provider], предоставляющий доступ к чату с определённым [username].
  ///
  /// Copied from [chat].
  ChatProvider call(
    String username,
  ) {
    return ChatProvider(
      username,
    );
  }

  @override
  ChatProvider getProviderOverride(
    covariant ChatProvider provider,
  ) {
    return call(
      provider.username,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatProvider';
}

/// [Provider], предоставляющий доступ к чату с определённым [username].
///
/// Copied from [chat].
class ChatProvider extends AutoDisposeProvider<APIChatResponse?> {
  /// [Provider], предоставляющий доступ к чату с определённым [username].
  ///
  /// Copied from [chat].
  ChatProvider(
    String username,
  ) : this._internal(
          (ref) => chat(
            ref as ChatRef,
            username,
          ),
          from: chatProvider,
          name: r'chatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$chatHash,
          dependencies: ChatFamily._dependencies,
          allTransitiveDependencies: ChatFamily._allTransitiveDependencies,
          username: username,
        );

  ChatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.username,
  }) : super.internal();

  final String username;

  @override
  Override overrideWith(
    APIChatResponse? Function(ChatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatProvider._internal(
        (ref) => create(ref as ChatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        username: username,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<APIChatResponse?> createElement() {
    return _ChatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatProvider && other.username == username;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, username.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatRef on AutoDisposeProviderRef<APIChatResponse?> {
  /// The parameter `username` of this provider.
  String get username;
}

class _ChatProviderElement extends AutoDisposeProviderElement<APIChatResponse?>
    with ChatRef {
  _ChatProviderElement(super.provider);

  @override
  String get username => (origin as ChatProvider).username;
}

String _$chatsHash() => r'25c7cd5a0951481566409c43698998f890b8b9ca';

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
