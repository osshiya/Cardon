import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/audio/audio_controller.dart';
import 'package:myapp/audio/sfx.dart';
import 'package:myapp/style/palette.dart';
import 'package:myapp/play_session/playing_area_card_widget.dart';
import 'package:myapp/game_internals/playing_area.dart';
import 'package:myapp/game_internals/playing_card.dart';
import 'package:myapp/game_internals/player.dart';
import 'package:myapp/play_session/playing_card_widget.dart';

enum PlayerAction { next, prev }

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;
  final Player player;
  final String roomId;
  final bool currentPlayer;
  final List currentPlayers;

  const PlayingAreaWidget(this.area, this.player, this.roomId,
      this.currentPlayer, this.currentPlayers,
      {super.key});

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  bool isHighlighted = false;

  void updateCurrentPlayer(PlayerAction action) async {
    try {
      switch (action) {
        case PlayerAction.next:
          String lastPlayer = widget.currentPlayers[
              widget.currentPlayers.length - 1]; // Get the last player
          widget.currentPlayers
              .insert(0, lastPlayer); // Move the last player to the beginning
          widget.currentPlayers
              .removeLast(); // Remove the last occurrence of the player
          break;
        case PlayerAction.prev:
          String firstPlayer = widget.currentPlayers[0]; // Get the first player
          widget.currentPlayers
              .add(firstPlayer); // Move the first player to the end
          widget.currentPlayers
              .removeAt(0); // Remove the first occurrence of the player
          break;
      }

      try {
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(widget.roomId)
            .update({'currentPlayers': widget.currentPlayers});
        print(widget.roomId);
        print(widget.currentPlayers);
        print('Current player updated successfully');
      } catch (e) {
        print(widget.roomId);
        print(widget.currentPlayers);
        print('Error updating current player: $e');
      }

      print('Current player updated successfully');
    } catch (e) {
      print('Error updating current player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return LimitedBox(
      maxHeight: 200,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DragTarget<PlayingCardDragData>(
          builder: (context, candidateData, rejectedData) => Material(
            color: isHighlighted ? palette.accept : palette.trueWhite,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: palette.redPen,
              onTap: _onAreaTap,
              child: StreamBuilder(
                  // Rebuild the card stack whenever the area changes
                  // (either by a player action, or remotely).
                  stream: widget.area.allChanges,
                  builder: (context, child) => _CardStack(
                      widget.area.cards, widget.player, widget.currentPlayer)),
            ),
          ),
          // onWillAcceptWithDetails: _onDragWillAccept,
          onLeave: _onDragLeave,
          onAcceptWithDetails: _onDragAccept,
        ),
      ),
    );
  }

  void _onAreaTap() {
    if (widget.currentPlayer) {
      // widget.area.removeFirstCard();
      widget.player.addCard();
      final audioController = context.read<AudioController>();
      audioController.playSfx(SfxType.huhsh);
    }
  }

  void _onDragAccept(DragTargetDetails<PlayingCardDragData> details) {
    widget.area.acceptCard(details.data.card);
    details.data.holder.removeCard(details.data.card);
    setState(() => isHighlighted = false);

    updateCurrentPlayer(PlayerAction.next);
  }

  void _onDragLeave(PlayingCardDragData? data) {
    setState(() => isHighlighted = false);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingCardDragData> details) {
    setState(() => isHighlighted = true);
    return true;
  }
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 6;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  static const double _maxWidth =
      _maxCards * _leftOffset + PlayingCardWidget.width;

  static const _maxHeight = _maxCards * _topOffset + PlayingCardWidget.height;

  final List<PlayingCard> cards;
  final Player player;
  final bool currentPlayer;

  const _CardStack(this.cards, this.player, this.currentPlayer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, cards.length - _maxCards);
                i < cards.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingAreaCardWidget(cards[i], player, currentPlayer),
              ),
          ],
        ),
      ),
    );
  }
}
