import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/style/palette.dart';
import 'package:myapp/style/timer_paint.dart';
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
    final palette = Provider.of<Palette>(context);
    final double progress = _remainingTime / 30;

    return Center(
      child: Container(
        width: 100, // Adjust the width and height as needed
        height: 100,
        child: CustomPaint(
          painter: TimerPainter(progress: progress, color: palette.timer),
          child: Center(
            child: Text(
              '$_remainingTime',
              style: TextStyle(
                fontFamily: 'Madimi One',
                color: palette.trueWhite,
                fontSize: 25,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
