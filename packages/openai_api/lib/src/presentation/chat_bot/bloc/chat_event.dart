part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.started() = _Started;

  const factory ChatEvent.getChat() = _GetChat;
  const factory ChatEvent.changeTextAnimation(bool animationPlay) =
      _ChangeTextAnimation;

  const factory ChatEvent.sendChat(String content) = _SendChat;

  const factory ChatEvent.getConversation(int conversationId) =
      _GetConversation;

  const factory ChatEvent.clearConversation() = _ClearConversation;

  ///[🔊 Text to speech event]
  const factory ChatEvent.initialTextToSpeechService() =
      _InitialTextToSpeechService;

  const factory ChatEvent.startSpeechText({
    required String content,
    required String messageSpeechId,
  }) = _StartSpeechText;

  const factory ChatEvent.stopSpeechText() = _StopSpeechText;

  const factory ChatEvent.cancelSpeechText({
    required String messageId,
    required String previousMessageId,
    required Function() functionCall,
  }) = _CancelSpeechText;

  ///[🎙️Speech to text event]

  const factory ChatEvent.initialSpeechToTextService() =
      _InitialSpeechToTextService;

  const factory ChatEvent.startListenSpeech() = _StartListenSpeech;

  const factory ChatEvent.stopListenSpeech() = _StopListenSpeech;

  const factory ChatEvent.listeningCompletedEvent() = _ListeningCompletedEvent;

  const factory ChatEvent.updateText(String newText) = _UpdateText;
}
