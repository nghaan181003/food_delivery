import 'package:openai_api/src/domain/entity/chat/chat_type.dart';
import 'package:openai_api/src/domain/entity/thread/thread_chat.dart';
import 'package:openai_api/src/utils/app_exception.dart';

abstract class ThreadRepositories {
  Future<SResult<List<ThreadChat>>> getThreadMessages(
      {required String threadId, int? limit});
  Future<SResult> runThread({required String threadId, String? asssistantId});
  Future<SResult> sendThreadMessage(
      {required String threadId,
      required String content,
      required ChatType type});
  void testRunThread({required String threadId, String? asssistantId});
}
