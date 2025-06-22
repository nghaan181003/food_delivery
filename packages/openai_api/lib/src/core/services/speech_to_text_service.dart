import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';


@injectable
class SpeechToTextService {
  late SpeechToText speechToText;

  SpeechToTextService();

  // String _currentLocaleId = 'en-US';
  //Viet nam
  String _currentLocaleId = 'vi-VN';

  Future<bool> initSpeechToText(Function(String) statusListener) async {
    speechToText = SpeechToText();
    var hasSpeech = await speechToText.initialize(
      onError: (val) => debugPrint('onError: $val'),
      debugLogging: true,
    );
    if (hasSpeech) {
      speechToText.statusListener = statusListener;
      var systemLocale = await speechToText.systemLocale();
      // _currentLocaleId = systemLocale?.localeId ?? 'en-US';

      return true;
    }

    return false;
  }

  void startSpeak(Function(String) callback) {
    speechToText.listen(
      cancelOnError: true,
      listenFor: const Duration(seconds: 30), // Maximum to listen is 30s
      pauseFor: const Duration(seconds: 3), // Maximum if not detected is 5s
      localeId: _currentLocaleId,
      onResult: (value) {
        callback(value.recognizedWords);
      },
    );
  }

  Future<void> stopSpeak() async {
    if (speechToText.isAvailable) {
      await speechToText.stop();
    }
  }
}
