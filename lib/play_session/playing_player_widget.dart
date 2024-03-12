import 'package:flutter/material.dart';

class PlayingPlayerWidget extends StatefulWidget {
  final List currentPlayers;

  const PlayingPlayerWidget(this.currentPlayers, {Key? key}) : super(key: key);

  @override
  State<PlayingPlayerWidget> createState() => _PlayingPlayerWidgetState();
}

class _PlayingPlayerWidgetState extends State<PlayingPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    List sortedPlayers = List.from(widget.currentPlayers);
    sortedPlayers.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sortedPlayers.map((player) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${player['name']}: ${player['cardCount']}',
              style: TextStyle(fontSize: 18),
            ),
          );
        }).toList(),
      ),
    );
  }
}