// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:myapp/game_internals/playing_timer.dart';
import 'package:myapp/play_session/playing_timer_widget.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'player_hand_widget.dart';
import 'playing_area_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  late PlayingTimer playingTimer;

  @override
  void initState() {
    super.initState();
    // Initialize the playing timer
    playingTimer = PlayingTimer();
  }

  @override
  void dispose() {
    // Stop the timer when the widget is disposed
    playingTimer.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlayingTimerWidget(playingTimer),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(child: PlayingAreaWidget(boardState.playingArea)),
              // SizedBox(width: 20),
              // Expanded(child: PlayingAreaWidget(boardState.areaTwo)),
            ],
          ),
        ),
        PlayerHandWidget(),
      ],
    );
  }
}