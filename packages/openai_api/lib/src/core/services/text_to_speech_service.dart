import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';

@injectable
class TextToSpeechService {
  late FlutterTts flutterTts;

  TextToSpeechService();

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> initTextToSpeech() async {
    flutterTts = FlutterTts();
    await _setAwaitOptions();

    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );

    flutterTts.setStartHandler(() {
      debugPrint('Playing');
    });

    flutterTts.setCompletionHandler(() {
      debugPrint('Complete');
    });

    flutterTts.setCancelHandler(() {
      if (Platform.isAndroid) {
        debugPrint('Cancel');
      }
    });

    flutterTts.setErrorHandler((msg) {
      debugPrint('Error: $msg');
    });
  }

  Future<void> startHandler({
    required String text,
    String? language,
  }) async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setLanguage(language ?? "vi");
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  // Future<void> completionHandler() async {}
  Future<void> cancelHandler() async {
    await flutterTts.stop();
  }
}
