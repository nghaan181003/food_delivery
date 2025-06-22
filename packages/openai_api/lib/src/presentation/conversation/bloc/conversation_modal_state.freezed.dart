// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_modal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversationModalState {
  List<Conversation> get conversations => throw _privateConstructorUsedError;
  List<Conversation> get selectedConversations =>
      throw _privateConstructorUsedError;

  /// Create a copy of ConversationModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModalStateCopyWith<ConversationModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModalStateCopyWith<$Res> {
  factory $ConversationModalStateCopyWith(ConversationModalState value,
          $Res Function(ConversationModalState) then) =
      _$ConversationModalStateCopyWithImpl<$Res, ConversationModalState>;
  @useResult
  $Res call(
      {List<Conversation> conversations,
      List<Conversation> selectedConversations});
}

/// @nodoc
class _$ConversationModalStateCopyWithImpl<$Res,
        $Val extends ConversationModalState>
    implements $ConversationModalStateCopyWith<$Res> {
  _$ConversationModalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? selectedConversations = null,
  }) {
    return _then(_value.copyWith(
      conversations: null == conversations
          ? _value.conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<Conversation>,
      selectedConversations: null == selectedConversations
          ? _value.selectedConversations
          : selectedConversations // ignore: cast_nullable_to_non_nullable
              as List<Conversation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationViewStateImplCopyWith<$Res>
    implements $ConversationModalStateCopyWith<$Res> {
  factory _$$ConversationViewStateImplCopyWith(
          _$ConversationViewStateImpl value,
          $Res Function(_$ConversationViewStateImpl) then) =
      __$$ConversationViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Conversation> conversations,
      List<Conversation> selectedConversations});
}

/// @nodoc
class __$$ConversationViewStateImplCopyWithImpl<$Res>
    extends _$ConversationModalStateCopyWithImpl<$Res,
        _$ConversationViewStateImpl>
    implements _$$ConversationViewStateImplCopyWith<$Res> {
  __$$ConversationViewStateImplCopyWithImpl(_$ConversationViewStateImpl _value,
      $Res Function(_$ConversationViewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? selectedConversations = null,
  }) {
    return _then(_$ConversationViewStateImpl(
      conversations: null == conversations
          ? _value._conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<Conversation>,
      selectedConversations: null == selectedConversations
          ? _value._selectedConversations
          : selectedConversations // ignore: cast_nullable_to_non_nullable
              as List<Conversation>,
    ));
  }
}

/// @nodoc

class _$ConversationViewStateImpl implements _ConversationViewState {
  const _$ConversationViewStateImpl(
      {required final List<Conversation> conversations,
      final List<Conversation> selectedConversations = const []})
      : _conversations = conversations,
        _selectedConversations = selectedConversations;

  final List<Conversation> _conversations;
  @override
  List<Conversation> get conversations {
    if (_conversations is EqualUnmodifiableListView) return _conversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversations);
  }

  final List<Conversation> _selectedConversations;
  @override
  @JsonKey()
  List<Conversation> get selectedConversations {
    if (_selectedConversations is EqualUnmodifiableListView)
      return _selectedConversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedConversations);
  }

  @override
  String toString() {
    return 'ConversationModalState(conversations: $conversations, selectedConversations: $selectedConversations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationViewStateImpl &&
            const DeepCollectionEquality()
                .equals(other._conversations, _conversations) &&
            const DeepCollectionEquality()
                .equals(other._selectedConversations, _selectedConversations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_conversations),
      const DeepCollectionEquality().hash(_selectedConversations));

  /// Create a copy of ConversationModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationViewStateImplCopyWith<_$ConversationViewStateImpl>
      get copyWith => __$$ConversationViewStateImplCopyWithImpl<
          _$ConversationViewStateImpl>(this, _$identity);
}

abstract class _ConversationViewState implements ConversationModalState {
  const factory _ConversationViewState(
          {required final List<Conversation> conversations,
          final List<Conversation> selectedConversations}) =
      _$ConversationViewStateImpl;

  @override
  List<Conversation> get conversations;
  @override
  List<Conversation> get selectedConversations;

  /// Create a copy of ConversationModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationViewStateImplCopyWith<_$ConversationViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
