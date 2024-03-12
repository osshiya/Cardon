import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/game_internals/board_state.dart';
import 'package:myapp/game_internals/playing_area.dart';
import 'package:myapp/play_session/playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  final PlayingArea area;
  final bool currentPlayer;

  const PlayerHandWidget(this.area, this.currentPlayer, {super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: PlayingCardWidget.height),
        child: ListenableBuilder(
          // Make sure we rebuild every time there's an update
          // to the player's hand.
          listenable: boardState.player,
          builder: (context, child) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ...boardState.player.hand.map((card) => PlayingCardWidget(
                    card, boardState.player, currentPlayer, area)),
              ],
            );
          },
        ),
      ),
    );
  }
}
