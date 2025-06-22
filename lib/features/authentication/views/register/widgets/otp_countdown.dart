import 'package:food_delivery_h2d/utils/popups/loaders.dart';

class OtpCountdown {
  bool _isActive = false;
  late Duration _time;
  // late Duration _fullTime;

  int expiredTime = 5;

  void init() {
    _time = Duration(minutes: expiredTime, seconds: 0);
  }

  void stop() {
    _isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      _isActive = true;
    }
  }

  String returnTime(Duration t) {
    String minutes =
        (t.inMinutes < 10) ? '0${t.inMinutes}' : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds = (numSeconds < 10) ? '0$numSeconds' : numSeconds.toString();
    String formattedTime = "$minutes:$seconds";
    return formattedTime;
  }

  Stream<String> stream() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (_) {
      String time;
      if (_isActive) {
        _time = _time - const Duration(seconds: 1);
        if (_time.inSeconds < 1) {
          _isActive = false;
          Loaders.successSnackBar(title: "Hết hạn");
        }
      }
      time = returnTime(_time);
      return time;
    });
  }
}
