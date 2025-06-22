import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/domain/repository/conversation_repositories.dart';
import 'package:openai_api/src/utils/app_exception.dart';

@injectable
class ConversationUserCase {
  final ConversationRepositories _conversationRepositories;

  ConversationUserCase(this._conversationRepositories);

  Future<SResult<List<Conversation>>> getConversations() =>
      _conversationRepositories.getConversations();

  Future<SResult<Conversation>> createdConversation() async {
    final createThread = await _conversationRepositories.createThread();
    if (createThread.isLeft) {
      return Left(AppException(message: "Failed to create thread"));
    }
    final data = createThread.right;
    if (data.id == null) {
      return Left(AppException(message: "Failed to create thread"));
    }
    return _conversationRepositories.createdConversation(
        threadId: createThread.right.id!);
  }

  Future<SResult<bool>> deleteConversation(int conversationId) async {
    final conversation = await _conversationRepositories.getConversationById(
      conversationId,
    );
    if (conversation.isLeft) {
      return Left(AppException(message: "Conversation not found"));
    }
    final data = conversation.right;
    if (data.threadId == null) {
      return Left(AppException(message: "Conversation not found"));
    }
    final threadId = data.threadId;
    if (threadId == null) {
      return Left(AppException(message: "Conversation not found"));
    }
    final deleteThread = await _conversationRepositories.deleteThread(threadId);
    if (deleteThread.isLeft) {
      return Left(AppException(message: "Failed to delete thread"));
    }
    return _conversationRepositories.deleteConversation(conversationId);
  }

  Future<SResult<Conversation>> updateConversation({
    required int conversationId,
    required String title,
    required String lastMessage,
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
}
