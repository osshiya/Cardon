import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/game_internals/card_suit.dart';
import 'package:myapp/game_internals/player.dart';
import 'package:myapp/game_internals/playing_card.dart';
import 'package:myapp/style/palette.dart';

class PlayingAreaCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 57.1;

  static const double height = 88.9;

  final PlayingCard card;

  final Player? player;

  final bool currentPlayer;

  const PlayingAreaCardWidget(this.card, this.player, this.currentPlayer,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textColor = card.suit.color == CardSuitColor.red
        ? palette.redPen
        : card.suit.color == CardSuitColor.green
            ? palette.greenPen
            : card.suit.color == CardSuitColor.blue
                ? palette.bluePen
                : card.suit.color == CardSuitColor.yellow
                    ? palette.yellowPen
                    : palette.font;

    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.font),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text('${card.suit.asCharacter}\n${card.value}',
              textAlign: TextAlign.center),
        ),
      ),
    );

    /// Cards that aren't in a player's hand are not draggable.
    if (player == null) return cardWidget;
    return cardWidget;
    // }
  }
}
