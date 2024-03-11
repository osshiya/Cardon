// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sfx.dart';
// import '../multiplayer/old_firestore_controller.dart';
import '../style/confetti.dart';
import '../style/button.dart';
import '../style/palette.dart';

import 'package:myapp/settings/settings.dart';
import '../player_progress/player_progress.dart';
import '../multiplayer/firestore_controller.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class RoomScreen extends StatefulWidget {
  final String roomId;

  const RoomScreen({super.key, required this.roomId});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Stream<Room> _roomStream;
  late String roomId;
  List<Map<String, dynamic>> players = [];

  @override
  void initState() {
    super.initState();

    roomId = widget.roomId;

    final playerProgress = Provider.of<PlayerProgress>(context, listen: false);
    playerProgress.setLastRoomID(roomId);

    _roomStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) => Room.fromSnapshot(snapshot));

    // Listen to changes in the stream and update players list accordingly
    _roomStream.listen((room) {
      setState(() {
        players = room.players;
      });

      // Check if the game has started
      if (room.gameStarted) {
        GoRouter.of(context).go('/play');
      }
    });
  }

  void notifyGameStart() async {
    try {
      // Update a field in Firestore to indicate that the game has started
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .update({'gameStarted': true});

    } catch (e) {
      // Handle any errors that occur during the update process
      print('Error notifying game start: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settings = context.watch<SettingsController>();

    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        semanticLabel: 'Home',
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
              Text(roomId),
              // const Spacer(),
              // The actual UI of the game.
              Expanded(
                child: StreamBuilder<Room>(
                  stream: _roomStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final room = snapshot.data!;
                      players = room.players;
                      return ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return ListTile(
                            title: Text(player['name'] ?? 'Unknown'),
                            subtitle: Text(
                                player['uid'].toString() ?? 'No UID found'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  onPressed: players.isNotEmpty &&
                          players[0]['uid'].toString() ==
                              settings.playerUID.value.toString()
                      ? () {
                          notifyGameStart();
                        }
                      : null,
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Room {
  final String roomId;
  final String roomName;
  final List<Map<String, dynamic>> players;
  final int numberOfPlayers;
  final bool gameStarted;

  Room(
      {required this.roomId,
      required this.roomName,
      required this.players,
      required this.numberOfPlayers,
      required this.gameStarted});

  factory Room.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final players = data['players'] as List<dynamic>;

    return Room(
      roomId: snapshot.id,
      roomName: data['roomName'] ?? '',
      players: players
          .map((player) => {
                'uid': player['uid'].toString(),
                'name': player['name'].toString(),
              })
          .toList(),
      numberOfPlayers: players.length,
      gameStarted: data['gameStarted'] ?? false
    );
  }
}
