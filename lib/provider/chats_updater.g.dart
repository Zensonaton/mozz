// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_updater.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewMessageUpdate _$NewMessageUpdateFromJson(Map<String, dynamic> json) =>
    NewMessageUpdate(
      id: (json['id'] as num).toInt(),
      dialog: json['dialog'] as String,
      text: json['text'] as String,
      timestamp: dateTimefromUnix((json['timestamp'] as num).toInt()),
      sender: json['sender'] as String,
      fromSelf: json['from_self'] as bool,
    );

Map<String, dynamic> _$NewMessageUpdateToJson(NewMessageUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dialog': instance.dialog,
      'text': instance.text,
      'timestamp': dateTimeToUnix(instance.timestamp),
      'sender': instance.sender,
      'from_self': instance.fromSelf,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatsUpdaterHash() => r'8b6b265e5d8f8f1f514b2f908251f0e8a6cbb699';

/// [Provider] для [ChatsUpdater].
///
/// Copied from [chatsUpdater].
@ProviderFor(chatsUpdater)
final chatsUpdaterProvider = Provider<ChatsUpdater>.internal(
  chatsUpdater,
  name: r'chatsUpdaterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatsUpdaterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatsUpdaterRef = ProviderRef<ChatsUpdater>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
