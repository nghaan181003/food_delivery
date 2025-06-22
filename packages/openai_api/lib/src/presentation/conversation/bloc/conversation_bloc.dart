import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/domain/usecase/conversation_usecase.dart';
import 'package:openai_api/src/presentation/conversation/bloc/conversation_modal_state.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

part 'conversation_bloc.freezed.dart';

@injectable
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationUserCase _conversationUserCase;
  ConversationBloc(this._conversationUserCase)
      : super(
          _Initial(
            data: ConversationModalState(
                conversations: List<Conversation>.empty(growable: true)),
          ),
        ) {
    on<_GetConversation>(_onGetConversation);
    on<_CreateConversation>(_onCreateConversation);
    on<_DeleteConversation>(_onDeleteConversation);
    on<_SelectConversation>(_onSelectConversation);
    on<_UpdateConversation>(_onUpdateConversation);
    on<_UpdateSelectedConversation>(_onUpdateSelectConversations);
  }

  ConversationModalState get data => state.data;

  FutureOr<void> _onSelectConversation(
    _SelectConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(_Loading(data: data));
    // if (CommonAppSettingPref.getAccessToken().isEmpty) {
    //   return emit(_SelectConversationFailed(data: data));
    // }
    return emit(
      _SelectConversationSuccess(
          data: data, conversationId: event.conversationId),
    );
  }

  FutureOr<void> _onGetConversation(
    _GetConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(_Loading(data: data));

    (await _conversationUserCase.getConversations()).fold(
      (left) => emit(_GetConversationFailed(data: data, message: left.message)),
      (right) => emit(
        _GetConversationSuccess(data: data.copyWith(conversations: right)),
      ),
    );
  }

  FutureOr<void> _onCreateConversation(
    _CreateConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(_Loading(data: data));
    (await _conversationUserCase.createdConversation()).fold(
      (left) =>
          emit(_CreateConversationFailed(data: data, message: left.message)),
      (right) => emit(_CreateConversationSuccess(
        data: data.copyWith(conversations: [right, ...data.conversations]),
      )),
    );
  }

  FutureOr<void> _onDeleteConversation(
    _DeleteConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(_Loading(data: data));
    (await _conversationUserCase.deleteConversation(event.conversationId)).fold(
      (left) =>
          emit(_DeleteConversationFailed(data: data, message: left.message)),
      (right) => emit(
        _DeleteConversationSuccess(
          data: data.copyWith(
            conversations: data.conversations
                .where((element) => element.id != event.conversationId)
                .toList(),
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateConversation(
    _UpdateConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(_Loading(data: data));
    (await _conversationUserCase.updateConversation(
            conversationId: event.conversationId,
            title: event.title ??
                data.conversations
                    .firstWhere((element) => element.id == event.conversationId)
                    .title,
            lastMessage: event.lastMessage,
            lastUpdated: DateTime.now()))
        .fold(
      (left) =>
          emit(_UpdateConversationFailed(data: data, message: left.message)),
      (right) => emit(_UpdateConversationSuccess(
          data: data.copyWith(
              conversations: data.conversations.map((e) {
        if (e.id == right.id) {
          return right;
        }
        return e;
      }).toList()))),
    );
  }

  FutureOr<void> _onUpdateSelectConversations(
    _UpdateSelectedConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(_Loading(data: data));
    if (data.selectedConversations
        .any((element) => element.id == event.conversation.id)) {
      emit(_UpdateSelectedConversationFailed(
          data: data.copyWith(
              selectedConversations: data.selectedConversations
                  .where((element) => element.id != event.conversation.id)
                  .toList())));
    } else {
      emit(_UpdateSelectedConversationSuccess(
          data: data.copyWith(selectedConversations: [
        ...data.selectedConversations,
        event.conversation,
      ])));
    }
  }
}
