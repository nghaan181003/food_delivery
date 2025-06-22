
import 'package:openai_api/src/data/models/thread/create_thread_response.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/utils/app_exception.dart';

abstract class ConversationRepositories {
  Future<SResult<List<Conversation>>> getConversations();
  Future<SResult<Conversation>> createdConversation({required String threadId});
  Future<SResult<Conversation>> updateConversation(
      Conversation newConversation);
  Future<SResult<bool>> deleteConversation(int conversationId);
  Future<SResult<Conversation>> getConversationById(int conversationId);
  Future<SResult<CreateThreadResponse>> createThread();
  Future<SResult> deleteThread(String threadId);
}
