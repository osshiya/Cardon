import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/player_progress/player_progress.dart';
import 'package:myapp/settings/settings.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sfx.dart';
import '../game_internals/card_suit.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';

class PlayingAreaCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 57.1;

  static const double height = 88.9;

  final PlayingCard card;

  final Player? player;

  final bool currentPlayer;

  final PlayingCard lastCard;

  const PlayingAreaCardWidget(
      this.card, this.player, this.currentPlayer, this.lastCard,
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
    // if (currentPlayer && (lastCard.suit == card.suit || lastCard.suit == CardSuit.all)) {
    //   return Draggable(
    //     feedback: Transform.rotate(
    //       angle: 0.1,
    //       child: cardWidget,
    //     ),
    //     data: PlayingCardDragData(card, player!),
    //     childWhenDragging: Opacity(
    //       opacity: 0.5,
    //       child: cardWidget,
    //     ),
    //     onDragStarted: () {
    //       print(lastCard);
    //       final audioController = context.read<AudioController>();
    //       audioController.playSfx(SfxType.huhsh);
    //     },
    //     onDragEnd: (details) {
    //       final audioController = context.read<AudioController>();
    //       audioController.playSfx(SfxType.wssh);
    //     },
    //     child: cardWidget,
    //   );
    // } else {
    //   // If the player is not the current player, return the card without draggable behavior
      return cardWidget;
    // }
  }
}