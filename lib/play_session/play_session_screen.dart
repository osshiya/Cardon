// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:myapp/settings/settings.dart';
import 'package:provider/provider.dart';

import 'package:myapp/audio/audio_controller.dart';
import 'package:myapp/audio/sfx.dart';
import 'package:myapp/multiplayer/firestore_controller.dart';
import 'package:myapp/style/confetti.dart';
import 'package:myapp/style/button.dart';
import 'package:myapp/style/palette.dart';
import 'package:myapp/game_internals/board_state.dart';
import 'package:myapp/play_session/board_widget.dart';
import 'package:myapp/player_progress/player_progress.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  late String roomId = '';

  late String playerUID = '';

  late String playerName = '';

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;

  late final PlayerProgress _playerProgress;

  FirestoreController? _firestoreController;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        Provider.value(value: _boardState),
      ],
      child: IgnorePointer(
        // Ignore all input during the celebration animation.
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          // The stack is how you layer widgets on top of each other.
          // Here, it is used to overlay the winning confetti animation on top
          // of the game.
          body: Stack(
            children: [
              // This is the main layout of the play session screen,
              // with a settings button at top, the actual play area
              // in the middle, and a back button at the bottom.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkResponse(
                          onTap: () => GoRouter.of(context).push('/'),
                          child: Image.asset(
                            'assets/images/settings.png',
                            semanticLabel: 'Exit game',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkResponse(
                          onTap: () => GoRouter.of(context).push('/settings'),
                          child: Image.asset(
                            'assets/images/settings.png',
                            semanticLabel: 'Settings',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // The actual UI of the game.
                  BoardWidget(),
                  Text("Drag cards to the two areas above."),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () => GoRouter.of(context).go('/'),
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _boardState.dispose();
    _firestoreController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    _boardState = BoardState(onWin: _playerWon);
    _playerProgress = context.read<PlayerProgress>();
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      _log.warning("Firestore instance wasn't provided. "
          "Running without _firestoreController.");
    } else {
      _firestoreController = FirestoreController(
          instance: firestore,
          boardState: _boardState,
          playerProgress: _playerProgress);
    }

    final playerProgress = Provider.of<PlayerProgress>(context, listen: false);
    roomId = playerProgress.lastRoomId;
    final settings = Provider.of<SettingsController>(context, listen: false);
    playerUID = settings.playerUID.value;
    playerName = settings.playerName.value;
  }

  void notifyGameEnd() async {
    try {
      // Update a field in Firestore to indicate that the game has started
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .update({'gameStarted': false, 'winner': playerName});
    } catch (e) {
      // Handle any errors that occur during the update process
      print('Error notifying game end: $e');
    }
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    notifyGameEnd();

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    // GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
