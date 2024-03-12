import 'package:flutter/material.dart';
import 'package:myapp/audio/audio_controller.dart';
import 'package:myapp/audio/sfx.dart';
import 'package:myapp/game_internals/card_suit.dart';
import 'package:myapp/game_internals/player.dart';
import 'package:myapp/game_internals/playing_card.dart';
import 'package:myapp/game_internals/playing_area.dart';
import 'package:myapp/style/palette.dart';
import 'package:provider/provider.dart';

class PlayingCardWidget extends StatelessWidget {
  static const double width = 57.1;
  static const double height = 88.9;

  final PlayingCard card;
  final Player? player;
  final bool currentPlayer;
  final PlayingArea area;

  const PlayingCardWidget(
    this.card,
    this.player,
    this.currentPlayer,
    this.area, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return StreamBuilder<PlayingCard>(
      stream: area.allChanges.map((_) {
        return area.cards.isNotEmpty
            ? area.cards.last
            : PlayingCard(CardSuit.all, 0);
      }),
      initialData: area.cards.isNotEmpty
          ? area.cards.last
          : PlayingCard(CardSuit.all, 0),
      builder: (context, snapshot) {
        final lastCard = snapshot.data!;

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
          style:
              Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: palette.trueWhite,
              border: Border.all(color: palette.font),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child:
                  Text('${card.suit.asCharacter}\n${card.value}', textAlign: TextAlign.center),
            ),
          ),
        );

        if (player == null) return cardWidget;

        if (currentPlayer &&
            (lastCard.suit == CardSuit.all ||
                lastCard.suit == card.suit ||
                lastCard.value == card.value)) {
          return Draggable(
            feedback: Transform.rotate(
              angle: 0.1,
              child: cardWidget,
            ),
            data: PlayingCardDragData(card, player!),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: cardWidget,
            ),
            onDragStarted: () {
              final audioController = context.read<AudioController>();
              audioController.playSfx(SfxType.huhsh);
            },
            onDragEnd: (details) {
              final audioController = context.read<AudioController>();
              audioController.playSfx(SfxType.wssh);
            },
            child: cardWidget,
          );
        } else {
          return cardWidget;
        }
      },
    );
  }
}

@immutable
class PlayingCardDragData {
  final PlayingCard card;
  final Player holder;

  const PlayingCardDragData(this.card, this.holder);
}
