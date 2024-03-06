import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sfx.dart';
import '../game_internals/playing_timer.dart';
import '../style/palette.dart';
import 'playing_timer_widget.dart';

class PlayingTimerWidget extends StatefulWidget {
  final PlayingTimer timer;

  const PlayingTimerWidget(this.timer, {Key? key}) : super(key: key);

  @override
  State<PlayingTimerWidget> createState() => _PlayingTimerWidgetState();
}

class _PlayingTimerWidgetState extends State<PlayingTimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${widget.timer.remainingTimeInSeconds}',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
