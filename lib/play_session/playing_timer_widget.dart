import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/game_internals/playing_timer.dart';

class PlayingTimerWidget extends StatefulWidget {
  final PlayingTimer timer;

  const PlayingTimerWidget(this.timer, {Key? key}) : super(key: key);

  @override
  State<PlayingTimerWidget> createState() => _PlayingTimerWidgetState();
}

class _PlayingTimerWidgetState extends State<PlayingTimerWidget> {
  late StreamSubscription<int> _timerSubscription;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _timerSubscription = widget.timer.timerStream.listen((remainingTime) {
      setState(() {
        _remainingTime = remainingTime;
      });
    });
  }

  @override
  void dispose() {
    _timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$_remainingTime',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
