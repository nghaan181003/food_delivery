import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/utils/app_exception.dart';

abstract class ChatRepositories {
  Future<SResult<List<Chat>>> getChats(int conversationId);
  Future<SResult<String>> sendMessage(List<Chat> chats);
  Future<SResult<int>> saveMessage(
      {required int conversationId, required Chat chat});
}
