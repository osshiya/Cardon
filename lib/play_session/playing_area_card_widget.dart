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
          color: textColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.8),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${card.suit.asCharacter}\n${card.value}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: palette.trueWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    /// Cards that aren't in a player's hand are not draggable.
    if (player == null) return cardWidget;
    return cardWidget;
    // }
  }
}
