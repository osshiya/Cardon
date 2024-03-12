// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:myapp/style/palette.dart';
import 'package:myapp/settings/settings.dart';
import 'package:myapp/player_progress/player_progress.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class RoomScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const RoomScreen({Key? key, required this.roomId, required this.roomName});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Stream<Room> _roomStream;
  late String playerUID = '';
  late String playerName = '';
  late List<Map<String, dynamic>> players = [];

  @override
  void initState() {
    super.initState();
    _initializeRoomStream();
  }

  @override
  void didUpdateWidget(RoomScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.roomId != oldWidget.roomId) {
      _initializeRoomStream();
    }
  }

  void _initializeRoomStream() {
    final settings = Provider.of<SettingsController>(context, listen: false);
    playerUID = settings.playerUID.value;
    playerName = settings.playerName.value;

    final playerProgress = Provider.of<PlayerProgress>(context, listen: false);
    playerProgress.setLastRoomID(widget.roomId);
    playerProgress.setLastRoomName(widget.roomName);

    try {
      _roomStream = FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .snapshots()
          .map((snapshot) => Room.fromSnapshot(snapshot));

      _roomStream.listen((r) {
        setState(() {
          players = r.players;
        });

        // Check if the game has started
        if (r.gameStarted) {
          GoRouter.of(context).go('/play');
        }
      });
    } catch (e) {
      print('Error initializing room stream: $e');
    }
  }

  void removePlayerFromRoom(BuildContext context) async {
    try {
      final updatedPlayers =
          players.where((player) => player['uid'] != playerUID).toList();

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .update({
        'players': updatedPlayers,
      });

      GoRouter.of(context).go('/join');
    } catch (e) {
      print('Error removing player from room: $e');
    }
  }

  void notifyGameStart() async {
    try {
      List<Map<String, dynamic>> currentPlayers = [];
      int count = 0;

      List<Map<String, dynamic>> shuffledPlayers = List.from(players);
      shuffledPlayers.shuffle();

      shuffledPlayers.forEach((player) {
        currentPlayers.add({
          'uid': player['uid'].toString(),
          'name': player['name'].toString(),
          'cardCount': 7,
          'order': count
        });
        count += 1;
      });

      // Update a field in Firestore to indicate that the game has started
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .update({
        'gameStarted': true,
        'currentPlayers': currentPlayers,
        'cards': []
      });
    } catch (e) {
      print('Error notifying game start: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settings = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      appBar: AppBar(
        backgroundColor: palette.backgroundPlaySession,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.blackPen),
          onPressed: () => removePlayerFromRoom(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: palette.blackPen),
            onPressed: () => GoRouter.of(context).push('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Room: ${widget.roomName}',
              style: TextStyle(
                fontFamily: 'Madimi One',
                fontSize: 32,
                color: palette.blackPen,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<Room>(
                stream: _roomStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: palette.pen,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: palette.redPen),
                      ),
                    );
                  } else {
                    final room = snapshot.data!;
                    return ListView.builder(
                      itemCount: room.players.length,
                      itemBuilder: (context, index) {
                        final player = room.players[index];
                        return ListTile(
                          title: Text(
                            player['name'] ?? 'Unknown',
                            style: TextStyle(color: palette.blackPen),
                          ),
                          subtitle: Text(
                            player['uid'].toString() ?? 'No UID found',
                            style: TextStyle(color: palette.blackPen),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            FilledButton(
              onPressed: players.isNotEmpty &&
                      // players.length >= 2 &&
                      // players.length <= 4 &&
                      players[0]['uid'].toString() ==
                          settings.playerUID.value.toString()
                  ? () {
                      notifyGameStart();
                    }
                  : null,
              child: Text(
                'Start Game',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
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
        gameStarted: data['gameStarted'] ?? false);
  }
}
