import 'package:either_dart/either.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/openai_api.dart';
import 'package:openai_api/src/data/models/conversation/conversation_model.dart';
import 'package:openai_api/src/data/models/thread/create_thread_response.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/domain/repository/conversation_repositories.dart';
import 'package:openai_api/src/utils/utils.dart';

@Injectable(as: ConversationRepositories)
class ConversationRepositoriesImpl implements ConversationRepositories {
  final Box<ConversationModel> _conversationBox;
  final GPTApi _api;
  ConversationRepositoriesImpl(this._conversationBox, this._api);

  @override
  Future<SResult<Conversation>> createdConversation(
      {required String threadId}) async {
    try {
      final conversation = ConversationModel(
        id: 0,
        threadId: threadId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      final id = await _conversationBox.add(conversation);
      conversation.id = id;
      await _conversationBox.put(id, conversation);
      return Right(conversation.toEntity);
    } catch (err) {
      return Left(AppException(message: err.toString()));
    }
  }

  @override
  Future<SResult<bool>> deleteConversation(int conversationId) async {
    try {
      await _conversationBox.delete(conversationId);
      return const Right(true);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<SResult<List<Conversation>>> getConversations() async {
    try {
      return Right(_conversationBox.values.map((e) => e.toEntity).toList());
    } catch (err) {
      return Left(AppException(message: err.toString()));
    }
  }

  @override
  Future<SResult<Conversation>> updateConversation(
      Conversation newConversation) async {
    try {
      final conversation = _conversationBox.get(newConversation.id);
      if (conversation == null) return Left(AppException(message: "Null"));
      conversation
        ..lastUpdate = newConversation.lastUpdate?.millisecondsSinceEpoch
        ..lastMessage = newConversation.lastMessage
        ..header = "JoJo"
        ..title = newConversation.title;
      await conversation.save();
      return Right(conversation.toEntity);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<SResult<Conversation>> getConversationById(int conversationId) async {
    try {
      final conversation = _conversationBox.get(conversationId);
      if (conversation == null) return Left(AppException(message: "Null"));
      return Right(conversation.toEntity);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<SResult<CreateThreadResponse>> createThread() async {
    try {
      final response = await _api.createThread({});
      if (response is DataFailed) {
        return Left(AppException(
            message: (response as DataFailed).dioError?.message ?? "Error"));
      }
      final data = response.data;
      if (data == null) return Left(AppException(message: "Null"));
      return Right(data);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<SResult> deleteThread(String threadId) async {
    try {
      final response = await _api.deleteThread(threadId);
      if (response is DataFailed) {
        return Left(AppException(
            message: (response as DataFailed).dioError?.message ?? "Error"));
      }
      return Right(response.data);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }
}
