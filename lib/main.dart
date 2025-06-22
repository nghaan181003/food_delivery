import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery_h2d/app.dart';
import 'package:food_delivery_h2d/firebase_options.dart';
import 'package:food_delivery_h2d/utils/helpers/env_helper.dart';
import 'package:get_storage/get_storage.dart';
import 'package:openai_api/openai_api.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  await dotenv.load(fileName: '.env');

  initChatBotConfig(
      apiKey: EnvHelper.openaiKey, assistantId: EnvHelper.assistantId);

  runApp(const App());
}
