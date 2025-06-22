import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/openai_api.dart';
import 'package:openai_api/src/core/configurations/open_ai_api_config.dart';
import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/domain/entity/chat/chat_status.dart';
import 'package:openai_api/src/domain/entity/chat/chat_type.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/domain/repository/chat_repositories.dart';
import 'package:openai_api/src/domain/repository/conversation_repositories.dart';
import 'package:openai_api/src/domain/repository/thread_repositories.dart';
import 'package:openai_api/src/utils/app_exception.dart';

@injectable
class ChatUseCase {
  final ChatRepositories _chatRepositories;
  final ConversationRepositories _conversationRepositories;
  final ThreadRepositories _threadRepositories;
  ChatUseCase(this._chatRepositories, this._conversationRepositories,
      this._threadRepositories);

  Future<SResult<List<Chat>>> getChats(int conversationId) =>
      _chatRepositories.getChats(conversationId);

  Future<SResult<int>> saveChat(int conversationId, Chat chat) async =>
      await _chatRepositories.saveMessage(
          conversationId: conversationId, chat: chat);

  Future<SResult<Chat>> sendChat(int conversationId) async {
    final chats = await getChats(conversationId);
    if (chats.isLeft) return Left(chats.left);

    final response = await _chatRepositories.sendMessage(chats.right);
    if (response.isLeft || (response.isRight && response.right.isEmpty)) {
      return Left(response.left);
    }

    final newChat = Chat(
      id: "0",
      conversationId: conversationId.toString(),
      title: response.right,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      chatStatus: ChatStatus.success,
      chatType: ChatType.assistant,
    );

    final saveResponseMess = await _chatRepositories.saveMessage(
        chat: newChat, conversationId: conversationId);
    if (saveResponseMess.isLeft) return Left(saveResponseMess.left);

    return Right(newChat.copyWith(id: saveResponseMess.right.toString()));
  }

  Future<SResult<String>> getTypeSpeech(String text) async {
    final response = await _chatRepositories.sendMessage([
      Chat(
        id: "0",
        conversationId: "0",
        title:
            'Phân tích câu này "$text" và phân tích giọng người việt nam hay người anh đọc. Nếu người việt thì trả về "vi" người nước ngoài thì là "en". Làm ơn trả lời cho tôi hoặc là "vi" hoặc là "en"',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        chatStatus: ChatStatus.success,
        chatType: ChatType.user,
      )
    ]);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }

  Future<SResult<Conversation>> updateConversation({
    required int conversationId,
    required String lastMessage,
    required String title,
    required DateTime lastUpdated,
  }) async =>
      _conversationRepositories.updateConversation(
        Conversation(
          id: conversationId,
          createdAt: DateTime.now(),
          lastMessage: lastMessage,
          lastUpdate: lastUpdated,
          title: title,
        ),
      );

  Future<SResult<Conversation>> getConversationById(int conversationId) =>
      _conversationRepositories.getConversationById(conversationId);

  Future<SResult<Chat>> sendThreadMessage({
    required int conversationId,
    required String threadId,
    required String content,
    required ChatType type,
  }) async {
    final sendThreadMessageResponse = await _threadRepositories
        .sendThreadMessage(threadId: threadId, content: content, type: type);
    if (sendThreadMessageResponse.isLeft) {
      return Left(sendThreadMessageResponse.left);
    }
    return (await _threadRepositories.runThread(
            threadId: threadId, asssistantId: ChatBotConfig().getAssistantId))
        .fold(
      (l) => Left(l),
      (r) async {
        final getMessageResponse = await _threadRepositories.getThreadMessages(
            threadId: threadId, limit: 1);
        if (getMessageResponse.isLeft) {
          return Left(getMessageResponse.left);
        }
        final message = getMessageResponse.right.first;
        final newChat = Chat(
          id: "0",
          conversationId: conversationId.toString(),
          title: message.content ?? "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          chatStatus: ChatStatus.success,
          chatType: ChatType.assistant,
        );
        final saveResponseMess = await _chatRepositories.saveMessage(
            chat: newChat, conversationId: conversationId);
        return Right(newChat.copyWith(id: saveResponseMess.right.toString()));
      },
    );
  }

  void testThreadRun({required String threadId}) {
    _threadRepositories.testRunThread(
        threadId: threadId, asssistantId: ChatBotConfig().getAssistantId);
  }
}
