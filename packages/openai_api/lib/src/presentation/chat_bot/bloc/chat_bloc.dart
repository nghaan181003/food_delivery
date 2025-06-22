import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/src/core/services/speech_to_text_service.dart';
import 'package:openai_api/src/core/services/text_to_speech_service.dart';
import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/domain/entity/chat/chat_status.dart';
import 'package:openai_api/src/domain/entity/chat/chat_type.dart';
import 'package:openai_api/src/domain/usecase/chat_usecase.dart';
import 'package:openai_api/src/presentation/chat_bot/bloc/chat_modal_state.dart';
import 'package:collection/collection.dart';

part 'chat_event.dart';
part 'chat_state.dart';

part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUseCase _chatUseCase;
  final SpeechToTextService _speechToTextService;
  final TextToSpeechService _textToSpeechService;
  ChatBloc(
    this._chatUseCase,
    this._speechToTextService,
    this._textToSpeechService,
  ) : super(
          _Initial(
              data: ChatModalState(chats: List<Chat>.empty(growable: true))),
        ) {
    on<_GetChat>(_onGetChat);
    on<_SendChat>(_onSendChat);
    on<_GetConversation>(_onGetConversation);
    on<_InitialTextToSpeechService>(_onInitialTextToSpeechService);
    on<_CancelSpeechText>(_onCancelSpeechText);
    on<_StartSpeechText>(_onStartSpeechText);
    on<_StopSpeechText>(_onStopSpeechText);
    on<_InitialSpeechToTextService>(_onInitialSpeechToText);
    on<_StartListenSpeech>(_onStartListenSpeech);
    on<_StopListenSpeech>(_onStopListenSpeech);
    on<_ListeningCompletedEvent>(_onListeningCompletedEvent);
    on<_ChangeTextAnimation>(_onChangeTextAnimation);
    on<_UpdateText>(_onUpdateText);
    on<_ClearConversation>(_onClearConversation);
  }
  ChatModalState get data => state.data;

  ///[🔊 Text to speech handler]
  FutureOr<void> _onInitialTextToSpeechService(
    _InitialTextToSpeechService event,
    Emitter<ChatState> emit,
  ) async {
    await _textToSpeechService.initTextToSpeech();
  }

  FutureOr<void> _onStartSpeechText(
    _StartSpeechText event,
    Emitter<ChatState> emit,
  ) async {
    if (state.loadingSend) {
      return;
    }
    try {
      if (state.listenSpeech) {
        await _speechToTextService.stopSpeak();
      }
      emit(_StartSpeechTextSuccess(
          data: data.copyWith(messageId: event.messageSpeechId)));
      var typeSpeech = (await _chatUseCase.getTypeSpeech(event.content))
              .fold((left) => "vi", (right) {
            if (right == "vi" || right == "en") {
              return right;
            }
          }) ??
          "vi";

      await _textToSpeechService.startHandler(
          text: event.content, language: typeSpeech);
      if (data.messageId == event.messageSpeechId) {
        emit(_StopSpeechTextSuccess(data: data.copyWith(messageId: null)));
      }
    } catch (exception) {
      emit(_StopSpeechTextSuccess(data: data.copyWith(messageId: null)));
    }
  }

  FutureOr<void> _onCancelSpeechText(
    _CancelSpeechText event,
    Emitter<ChatState> emit,
  ) {
    add(const _StopSpeechText());
    if (event.previousMessageId != event.messageId) {
      event.functionCall.call();
    }
  }

  FutureOr<void> _onClearConversation(
    _ClearConversation event,
    Emitter<ChatState> emit,
  ) {
    emit(_ClearConversationSuccess(data: data.copyWith(conversation: null)));
  }

  FutureOr<void> _onStopSpeechText(
    _StopSpeechText event,
    Emitter<ChatState> emit,
  ) async {
    emit(_StopSpeechTextSuccess(data: data.copyWith(messageId: null)));
    await _textToSpeechService.cancelHandler();
  }

  ///[🎙️Speech to text handler]
  FutureOr<void> _onInitialSpeechToText(
    _InitialSpeechToTextService event,
    Emitter<ChatState> emit,
  ) async {
    final initSpeech = await _speechToTextService.initSpeechToText((status) {
      log("🎙️[Status] $status");
      if (status == "done" && state is! _StopListeningSpeech) {
        add(const _ListeningCompletedEvent());
      }
    });
    if (initSpeech) {
      emit(
        _InitialSpeechToTextSuccess(data: data.copyWith(micAvailable: true)),
      );
    }
  }

  FutureOr<void> _onListeningCompletedEvent(
      _ListeningCompletedEvent event, Emitter<ChatState> emit) {
    emit(_ListeningCompleted(data: data));
  }

  FutureOr<void> _onStopListenSpeech(
    _StopListenSpeech event,
    Emitter<ChatState> emit,
  ) async {
    emit(_StopListeningSpeech(data: data));
    await _speechToTextService.stopSpeak();
  }

  FutureOr<void> _onStartListenSpeech(
    _StartListenSpeech event,
    Emitter<ChatState> emit,
  ) async {
    if (state.loadingSend) {
      return;
    }
    if (!data.micAvailable) {
      return;
    }
    try {
      if (state is _StartSpeechTextSuccess) {
        emit(_StopSpeechTextSuccess(data: data.copyWith(messageId: null)));
        await _textToSpeechService.cancelHandler();
      }
      emit(_ListeningSpeech(data: data, textResponse: ''));
      _speechToTextService.startSpeak(
        (text) {
          add(_UpdateText(text));
        },
      );
    } catch (exception) {
      add(const _StopListenSpeech());
    }
  }

  FutureOr<void> _onUpdateText(_UpdateText event, Emitter<ChatState> emit) {
    emit(_UpdateTextSuccess(data: data, textResponse: event.newText));
  }

  ///[🎉Chat handler]

  FutureOr<void> _onChangeTextAnimation(
    _ChangeTextAnimation event,
    Emitter<ChatState> emit,
  ) {
    emit(
      _ChangeTextAnimationSuccess(
          data: data.copyWith(textAnimation: event.animationPlay)),
    );
  }

  FutureOr<void> _onGetConversation(
    _GetConversation event,
    Emitter<ChatState> emit,
  ) async {
    emit(_Loading(data: data));
    (await _chatUseCase.getConversationById(event.conversationId)).fold(
      (left) => emit(_GetConversationFailed(data: data, message: left.message)),
      (right) => emit(
        _GetConversationSuccess(data: data.copyWith(conversation: right)),
      ),
    );
  }

  FutureOr<void> _onGetChat(
    _GetChat event,
    Emitter<ChatState> emit,
  ) async {
    if (data.conversation == null) {
      return;
    }
    emit(_Loading(data: data));
    (await _chatUseCase.getChats(data.conversation!.id)).fold(
      (left) => emit(_GetChatFailed(data: data, message: left.message)),
      (right) => emit(
        _GetChatSuccess(data: data.copyWith(chats: right.reversed.toList())),
      ),
    );
  }

  FutureOr<void> _onSendChat(
    _SendChat event,
    Emitter<ChatState> emit,
  ) async {
    // _chatUseCase.testThreadRun(threadId: GptConstant.threadId);
    if (data.conversation == null ||
        (data.conversation?.threadId?.isEmpty ?? false)) {
      return null;
    }
    if (state.loadingSend) return;
    emit(_LoadingSend(data: data));
    final sendMessage = Chat(
      id: 0.toString(),
      conversationId: data.conversation!.id.toString(),
      title: event.content,
      createdAt: DateTime.now(),
      chatStatus: ChatStatus.success,
      chatType: ChatType.user,
    );

    final saveSendMessage =
        await _chatUseCase.saveChat(data.conversation!.id, sendMessage);
    if (saveSendMessage.isLeft) {
      return emit(_SendChatFailed(
          data: data, message: "Save message ${saveSendMessage.left.message}"));
    }

    final loadingMessage = Chat(
      id: 0.toString(),
      conversationId: data.conversation!.id.toString(),
      title: "",
      createdAt: DateTime.now(),
      chatStatus: ChatStatus.loading,
      chatType: ChatType.assistant,
    );

    emit(
      state.copyWith(
        data: data.copyWith(chats: [
          loadingMessage,
          sendMessage.copyWith(id: saveSendMessage.right.toString()),
          ...data.chats
        ]),
      ),
    );
    return (await _chatUseCase.sendThreadMessage(
      conversationId: data.conversation!.id,
      threadId: data.conversation!.threadId!,
      content: event.content,
      type: ChatType.user,
    ))
        .fold(
      (left) => emit(_SendChatFailed(
          data: data.copyWith(
              chats: data.chats.sublist(1).mapIndexed((index, e) {
            if (index == 0) {
              return e.copyWith(chatStatus: ChatStatus.error);
            }
            return e;
          }).toList()),
          message: left.message)),
      (right) => emit(_SendChatSuccess(
        data: data.copyWith(chats: [right, ...data.chats.sublist(1)]),
      )),
    );
  }
}
