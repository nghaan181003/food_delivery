library openai_api;

import 'package:openai_api/openai_api.dart';
import 'package:openai_api/src/core/configurations/open_ai_api_config.dart';
export 'package:injectable/injectable.dart';
export 'package:openai_api/src/core/configurations/configurations.dart';
export 'package:openai_api/src/core/configurations/env/env_prod.dart';
export 'package:openai_api/src/core/dependency_injection/di.dart';
export 'package:openai_api/src/data/data_source/remote/gpt_api.dart';
export 'package:openai_api/src/data/data_source/remote/thread_api.dart';
export 'package:openai_api/src/presentation/chat_bot/views/chat_bot_view.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:openai_api/src/presentation/chat_bot/bloc/chat_bloc.dart';
export 'package:openai_api/src/presentation/conversation/bloc/conversation_bloc.dart';
export 'package:injectable/injectable.dart';

Future<void> initChatBotConfig({
  required String apiKey,
  required String assistantId,
  String? model,
  String? turboModel,
}) async {
  Configurations().setConfigurationValues(environmentProd);
  ChatBotConfig().setConfig(
    apiKey: apiKey,
    assistantId: assistantId,
    model: model ?? "gpt-4o-mini",
    turboModel: turboModel ?? "gpt-3.5-turbo",
  );
  await configureDependencies(environment: Environment.prod);
}
