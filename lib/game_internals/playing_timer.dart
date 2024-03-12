import 'dart:async';

class PlayingTimer {
  Timer? _timer;
  int _elapsedSeconds = 0;
  final int durationInSeconds = 30;

  // Constructor for PlayingTimer
  PlayingTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _onTimerTick);
  }

  void _onTimerTick(Timer timer) {
    if (_elapsedSeconds < durationInSeconds) {
      _elapsedSeconds++;
    } else {
      // Timer has expired
      _timer!.cancel();
    }
    // Notify listeners about the elapsed time
    // notifyListeners();
  }

  // Getter method to get the remaining time
  int get remainingTimeInSeconds => durationInSeconds - _elapsedSeconds;

  // Method to stop the timer
  void stopTimer() {
    _timer?.cancel();
  }
}
