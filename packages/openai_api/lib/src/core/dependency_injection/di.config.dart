// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;

import '../../../openai_api.dart' as _i602;
import '../../data/data_source/remote/gpt_api.dart' as _i536;
import '../../data/data_source/remote/stream_rest_api.dart' as _i64;
import '../../data/data_source/remote/thread_api.dart' as _i718;
import '../../data/models/chat/chat_model.dart' as _i214;
import '../../data/models/conversation/conversation_model.dart' as _i854;
import '../../data/repository/chat_repositories_impl.dart' as _i757;
import '../../data/repository/conversation_repository/conversation_repositorie_impl.dart'
    as _i264;
import '../../data/repository/thread_repository/thread_repositories_impl.dart'
    as _i185;
import '../../domain/repository/chat_repositories.dart' as _i243;
import '../../domain/repository/conversation_repositories.dart' as _i246;
import '../../domain/repository/thread_repositories.dart' as _i510;
import '../../domain/usecase/chat_usecase.dart' as _i647;
import '../../domain/usecase/conversation_usecase.dart' as _i108;
import '../../presentation/chat_bot/bloc/chat_bloc.dart' as _i536;
import '../../presentation/conversation/bloc/conversation_bloc.dart' as _i1068;
import '../services/speech_to_text_service.dart' as _i966;
import '../services/text_to_speech_service.dart' as _i475;
import 'modules/data_source_module.dart' as _i222;
import 'modules/storage_module.dart' as _i148;

const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final hiveModule = _$HiveModule();
  final dataSourceModule = _$DataSourceModule();
  gh.factory<_i475.TextToSpeechService>(() => _i475.TextToSpeechService());
  gh.factory<_i966.SpeechToTextService>(() => _i966.SpeechToTextService());
  await gh.singletonAsync<_i986.HiveInterface>(
    () => hiveModule.init(),
    preResolve: true,
  );
  gh.singleton<_i986.Box<_i854.ConversationModel>>(
      () => hiveModule.conversationBox(gh<_i986.HiveInterface>()));
  gh.singleton<_i986.Box<_i214.ChatModel>>(
      () => hiveModule.chatBox(gh<_i986.HiveInterface>()));
  gh.factory<_i361.Dio>(
    () => dataSourceModule.dioProd(),
    registerFor: {_prod},
  );
  gh.factory<_i536.GPTApi>(() => _i536.GPTApi(gh<_i361.Dio>()));
  gh.factory<_i64.StreamRestApi>(
      () => _i64.StreamRestApi(dio: gh<_i361.Dio>()));
  gh.factory<_i718.ThreadApi>(() => _i718.ThreadApi(gh<_i64.StreamRestApi>()));
  gh.factory<_i243.ChatRepositories>(
      () => _i757.ChatRepositoriesImpl(gh<_i602.GPTApi>()));
  gh.factory<_i246.ConversationRepositories>(
      () => _i264.ConversationRepositoriesImpl(
            gh<_i986.Box<_i854.ConversationModel>>(),
            gh<_i602.GPTApi>(),
          ));
  gh.factory<_i510.ThreadRepositories>(() => _i185.ThreadRepositoriesImpl(
        gh<_i602.GPTApi>(),
        gh<_i602.ThreadApi>(),
      ));
  gh.factory<_i647.ChatUseCase>(() => _i647.ChatUseCase(
        gh<_i243.ChatRepositories>(),
        gh<_i246.ConversationRepositories>(),
        gh<_i510.ThreadRepositories>(),
      ));
  gh.factory<_i108.ConversationUserCase>(
      () => _i108.ConversationUserCase(gh<_i246.ConversationRepositories>()));
  gh.factory<_i536.ChatBloc>(() => _i536.ChatBloc(
        gh<_i647.ChatUseCase>(),
        gh<_i966.SpeechToTextService>(),
        gh<_i475.TextToSpeechService>(),
      ));
  gh.factory<_i1068.ConversationBloc>(
      () => _i1068.ConversationBloc(gh<_i108.ConversationUserCase>()));
  return getIt;
}

class _$HiveModule extends _i148.HiveModule {}

class _$DataSourceModule extends _i222.DataSourceModule {}
