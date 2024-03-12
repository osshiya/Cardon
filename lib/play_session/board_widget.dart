// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:myapp/game_internals/board_state.dart';
import 'package:myapp/game_internals/player.dart';
import 'package:myapp/game_internals/playing_timer.dart';
import 'package:myapp/play_session/player_hand_widget.dart';
import 'package:myapp/play_session/playing_area_widget.dart';
import 'package:myapp/play_session/playing_timer_widget.dart';
import 'package:myapp/play_session/playing_player_widget.dart';
import 'package:myapp/player_progress/player_progress.dart';
import 'package:myapp/settings/settings.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  late Stream<Player> _playerStream;
  late bool currentPlayer = false;
  late String roomId = '';
  late String playerUID = '';
  late String playerName = '';
  late List currentPlayers = [];
  late PlayingTimer playingTimer;

  @override
  void initState() {
    super.initState();

    final playerProgress = Provider.of<PlayerProgress>(context, listen: false);
    roomId = playerProgress.lastRoomId;
    final settings = Provider.of<SettingsController>(context, listen: false);
    playerUID = settings.playerUID.value;
    playerName = settings.playerName.value;

    playingTimer = PlayingTimer();

    _playerStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) => Player.fromSnapshot(snapshot));

    // Listen to changes in the stream and update currentPlayer accordingly
    _playerStream.listen((player) {
      print(player);
      setState(() {
        currentPlayers = player.currentPlayers;
        currentPlayer = player.currentPlayers[0]['uid'] == playerUID;
      });
    });

    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      final gameEnded = snapshot.data()?['gameStarted'] == false;
      final winner = snapshot.data()?['winner'];
      if (gameEnded) {
        GoRouter.of(context).go('/play/won', extra: {'winner': winner});
      }
    });
  }

  @override
  void dispose() {
    // Stop the timer when the widget is disposed
    playingTimer.stopTimer();
    playingTimer.closeTimer();
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
        PlayingPlayerWidget(currentPlayers),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                child: PlayingAreaWidget(boardState.playingArea,
                    boardState.player, roomId, currentPlayer, currentPlayers, playingTimer),
              )
            ],
          ),
        ),
        PlayerHandWidget(boardState.playingArea, currentPlayer),
      ],
    );
  }
}
