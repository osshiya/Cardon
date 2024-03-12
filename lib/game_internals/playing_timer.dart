import 'dart:async';

class PlayingTimer {
  late StreamController<int> _timerController;
  late Timer _timer;
  int elapsedSeconds = 0;
  int durationInSeconds = 30;

  PlayingTimer() {
    _timerController = StreamController<int>();
  }

  Stream<int> get timerStream => _timerController.stream;

  void startTimer() {
    elapsedSeconds = durationInSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (elapsedSeconds > 0) {
        elapsedSeconds--;
        _timerController.add(elapsedSeconds);
      } else {
        _timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void closeTimer() {
    _timerController.close();
  }
}
