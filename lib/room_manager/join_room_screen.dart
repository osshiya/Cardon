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

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  late Stream<List<Room>> _roomsStream;
  String? _selectedRoomId;
  String? _selectedRoomName;

  @override
  void initState() {
    super.initState();
    _roomsStream = FirebaseFirestore.instance
        .collection('rooms')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromSnapshot(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settings = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => GoRouter.of(context).go('/'),
                    icon: Icon(Icons.arrow_back, color: palette.blackPen),
                  ),
                  IconButton(
                    onPressed: _refreshRooms,
                    icon: Icon(Icons.refresh, color: palette.blackPen),
                  ),
                  IconButton(
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    icon: Icon(Icons.settings, color: palette.blackPen),
                  ),
                ],
              ),
            ),
            Text(
              'Join Room',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Madimi One',
                fontSize: 34,
                color: palette.blackPen,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Room>>(
                stream: _roomsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: palette.pen),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: palette.blackPen)),
                    );
                  } else if (snapshot.hasData) {
                    final rooms = snapshot.data!;
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        final players = room.numberOfPlayers;
                        final isGameStarted = room.gameStarted;

                        if (!isGameStarted && players != 0 && players <= 5) {
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(room.roomName,
                                  style: TextStyle(color: palette.blackPen)),
                              subtitle: Text('Players: $players/4',
                                  style: TextStyle(
                                      color:
                                          palette.blackPen.withOpacity(0.7))),
                              onTap: () {
                                setState(() {
                                  _selectedRoomId = room.roomId;
                                  _selectedRoomName = room.roomName;
                                });
                              },
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: _selectedRoomId != null ? _joinRoom : null,
                child: Text('Join', style: TextStyle(color: palette.trueWhite)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshRooms() {
    setState(() {
      _roomsStream = FirebaseFirestore.instance
          .collection('rooms')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Room.fromSnapshot(doc)).toList());
    });
  }

  void _joinRoom() {
    final settings = context.read<SettingsController>();
    final Map<String, dynamic> currentPlayer = {
      'uid': settings.playerUID.value,
      'name': settings.playerName.value
    };
    FirebaseFirestore.instance.collection('rooms').doc(_selectedRoomId).update({
      'players': FieldValue.arrayUnion([currentPlayer])
    }).then((_) {
      print('Successfully joined room $_selectedRoomName: $_selectedRoomId');
      GoRouter.of(context).go('/room/$_selectedRoomId&$_selectedRoomName');
    }).catchError((error) {
      print('Failed to join room: $error');
    });
  }
}

class Room {
  final String roomId;
  final String roomName;
  final int numberOfPlayers;
  final bool gameStarted;

  Room(
      {required this.roomId,
      required this.roomName,
      required this.numberOfPlayers,
      required this.gameStarted});

  factory Room.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Room(
      roomId: snapshot.id,
      roomName: data['roomName'] ?? '',
      numberOfPlayers: (data['players'] as List<dynamic>).length,
      gameStarted: data['gameStarted'] ?? false,
    );
  }
}
