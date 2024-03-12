\import 'package:flutter/material.dart';
import 'package:myapp/style/palette.dart';
import 'package:provider/provider.dart';

class PlayingPlayerWidget extends StatefulWidget {
  final List currentPlayers;
  final int count;

  const PlayingPlayerWidget(this.currentPlayers, this.count, {Key? key}) : super(key: key);

  @override
  State<PlayingPlayerWidget> createState() => _PlayingPlayerWidgetState();
}

class _PlayingPlayerWidgetState extends State<PlayingPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    final palette = Provider.of<Palette>(context);

    List sortedPlayers = List.from(widget.currentPlayers);
    sortedPlayers
        .sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: sortedPlayers.map((player) {

          final bool isHighlighted = player['order'] == widget.count;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${player['name']}',
                    style: TextStyle(
                      fontFamily: 'Madimi One',
                      color: isHighlighted ? palette.greyPen : palette.blackPen,
                      fontSize: isHighlighted ? 21 : 25,
                      height: 1,
                      fontWeight: isHighlighted ? FontWeight.w100 : FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${player['cardCount']}',
                    style: TextStyle(
                      fontFamily: 'Madimi One',
                      color: isHighlighted ? palette.greyPen : palette.blackPen,
                      fontSize: isHighlighted ? 21 : 25,
                      height: 1,
                      fontWeight: isHighlighted ? FontWeight.w100 : FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
