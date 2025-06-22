// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_modal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatModalState {
  List<Chat> get chats => throw _privateConstructorUsedError;
  Conversation? get conversation => throw _privateConstructorUsedError;
  String? get messageId => throw _privateConstructorUsedError;
  bool get micAvailable => throw _privateConstructorUsedError;
  bool get textAnimation => throw _privateConstructorUsedError;

  /// Create a copy of ChatModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatModalStateCopyWith<ChatModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModalStateCopyWith<$Res> {
  factory $ChatModalStateCopyWith(
          ChatModalState value, $Res Function(ChatModalState) then) =
      _$ChatModalStateCopyWithImpl<$Res, ChatModalState>;
  @useResult
  $Res call(
      {List<Chat> chats,
      Conversation? conversation,
      String? messageId,
      bool micAvailable,
      bool textAnimation});

  $ConversationCopyWith<$Res>? get conversation;
}

/// @nodoc
class _$ChatModalStateCopyWithImpl<$Res, $Val extends ChatModalState>
    implements $ChatModalStateCopyWith<$Res> {
  _$ChatModalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chats = null,
    Object? conversation = freezed,
    Object? messageId = freezed,
    Object? micAvailable = null,
    Object? textAnimation = null,
  }) {
    return _then(_value.copyWith(
      chats: null == chats
          ? _value.chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<Chat>,
      conversation: freezed == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as Conversation?,
      messageId: freezed == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      micAvailable: null == micAvailable
          ? _value.micAvailable
          : micAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      textAnimation: null == textAnimation
          ? _value.textAnimation
          : textAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ChatModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationCopyWith<$Res>? get conversation {
    if (_value.conversation == null) {
      return null;
    }

    return $ConversationCopyWith<$Res>(_value.conversation!, (value) {
      return _then(_value.copyWith(conversation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatModalStateImplCopyWith<$Res>
    implements $ChatModalStateCopyWith<$Res> {
  factory _$$ChatModalStateImplCopyWith(_$ChatModalStateImpl value,
          $Res Function(_$ChatModalStateImpl) then) =
      __$$ChatModalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Chat> chats,
      Conversation? conversation,
      String? messageId,
      bool micAvailable,
      bool textAnimation});

  @override
  $ConversationCopyWith<$Res>? get conversation;
}

/// @nodoc
class __$$ChatModalStateImplCopyWithImpl<$Res>
    extends _$ChatModalStateCopyWithImpl<$Res, _$ChatModalStateImpl>
    implements _$$ChatModalStateImplCopyWith<$Res> {
  __$$ChatModalStateImplCopyWithImpl(
      _$ChatModalStateImpl _value, $Res Function(_$ChatModalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chats = null,
    Object? conversation = freezed,
    Object? messageId = freezed,
    Object? micAvailable = null,
    Object? textAnimation = null,
  }) {
    return _then(_$ChatModalStateImpl(
      chats: null == chats
          ? _value._chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<Chat>,
      conversation: freezed == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as Conversation?,
      messageId: freezed == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      micAvailable: null == micAvailable
          ? _value.micAvailable
          : micAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      textAnimation: null == textAnimation
          ? _value.textAnimation
          : textAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ChatModalStateImpl implements _ChatModalState {
  const _$ChatModalStateImpl(
      {required final List<Chat> chats,
      this.conversation,
      this.messageId,
      this.micAvailable = false,
      this.textAnimation = false})
      : _chats = chats;

  final List<Chat> _chats;
  @override
  List<Chat> get chats {
    if (_chats is EqualUnmodifiableListView) return _chats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chats);
  }

  @override
  final Conversation? conversation;
  @override
  final String? messageId;
  @override
  @JsonKey()
  final bool micAvailable;
  @override
  @JsonKey()
  final bool textAnimation;

  @override
  String toString() {
    return 'ChatModalState(chats: $chats, conversation: $conversation, messageId: $messageId, micAvailable: $micAvailable, textAnimation: $textAnimation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatModalStateImpl &&
            const DeepCollectionEquality().equals(other._chats, _chats) &&
            (identical(other.conversation, conversation) ||
                other.conversation == conversation) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.micAvailable, micAvailable) ||
                other.micAvailable == micAvailable) &&
            (identical(other.textAnimation, textAnimation) ||
                other.textAnimation == textAnimation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_chats),
      conversation,
      messageId,
      micAvailable,
      textAnimation);

  /// Create a copy of ChatModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatModalStateImplCopyWith<_$ChatModalStateImpl> get copyWith =>
      __$$ChatModalStateImplCopyWithImpl<_$ChatModalStateImpl>(
          this, _$identity);
}

abstract class _ChatModalState implements ChatModalState {
  const factory _ChatModalState(
      {required final List<Chat> chats,
      final Conversation? conversation,
      final String? messageId,
      final bool micAvailable,
      final bool textAnimation}) = _$ChatModalStateImpl;

  @override
  List<Chat> get chats;
  @override
  Conversation? get conversation;
  @override
  String? get messageId;
  @override
  bool get micAvailable;
  @override
  bool get textAnimation;

  /// Create a copy of ChatModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatModalStateImplCopyWith<_$ChatModalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
