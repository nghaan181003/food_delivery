import 'package:injectable/injectable.dart';
import 'package:openai_api/openai_api.dart';
import 'package:openai_api/src/core/configurations/configurations.dart';
import 'package:openai_api/src/core/configurations/env/env_prod.dart';
import 'package:openai_api/src/core/dependency_injection/di.dart';
import 'package:openai_api/src/data/data_source/remote/gpt_api.dart';
import 'package:openai_api/src/data/data_source/remote/thread_api.dart';

void main() async {
  Configurations().setConfigurationValues(environmentProd);
  await configureDependencies(environment: Environment.prod);
  final gptApi = injector.get<GPTApi>();
  final threadApi = injector.get<ThreadApi>();
  final createThreadResponse = await gptApi.createThread({
    "messages": [
      {"role": "user", "content": "Hello, how can you help me today?"}
    ]
  });
  final threadId = createThreadResponse.data?.id;
  if (threadId != null) {
    await gptApi.sendThreadMessage(
        threadId, {"role": "user", "content": "What's the weather like?"});
    final messages = await gptApi.threadMessages(threadId, {"limit": 10});
    threadApi.runThreads(
        threadId: threadId, body: {"assistant_id": "your_assistant_id"});
  }

  // BlocProvider(create: (context) => ,)
}
