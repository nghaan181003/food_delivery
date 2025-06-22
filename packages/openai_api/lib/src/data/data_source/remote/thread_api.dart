import 'package:injectable/injectable.dart';
import 'package:openai_api/src/core/configurations/configurations.dart';
import 'package:openai_api/src/data/data_source/remote/stream_rest_api.dart';

@injectable
class ThreadApi {
  final StreamRestApi _client;
  ThreadApi(this._client);

  String get _baseUrl => Configurations.baseUrl;
  String get _branch => "$_baseUrl/threads";

  void runThreads({required String threadId, Map<String, dynamic>? body}) {
    _client.ssePostStream(url: "$_branch/$threadId/runs", request: body);
  }
}
