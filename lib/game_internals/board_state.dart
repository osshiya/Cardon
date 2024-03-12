// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'package:myapp/game_internals/player.dart';
import 'package:myapp/game_internals/playing_area.dart';

class BoardState {
  final VoidCallback onWin;

  final PlayingArea playingArea = PlayingArea();

  final Player player = Player(currentPlayers: []);

  final String roomId = '';

  final bool currentPlayer = false;

  BoardState({required this.onWin}) {
    player.addListener(_handlePlayerChange);
  }

  List<PlayingArea> get areas => [playingArea];

  void dispose() {
    player.removeListener(_handlePlayerChange);
    playingArea.dispose();
  }

  void _handlePlayerChange() {
    if (player.hand.isEmpty) {
      onWin();
    }
  }
}
