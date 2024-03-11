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
                    alignment: Alignment.centerLeft,
                    child: InkResponse(
                      onTap: () => setState(() {
                        _roomsStream = FirebaseFirestore.instance
                            .collection('rooms')
                            .snapshots()
                            .map((snapshot) => snapshot.docs
                                .map((doc) => Room.fromSnapshot(doc))
                                .toList());
                      }),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Refresh',
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
              // const Spacer(),
              // The actual UI of the game.
              Expanded(
                child: StreamBuilder<List<Room>>(
                  stream: _roomsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child:
                            CircularProgressIndicator(), // Show loading indicator in the center
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Error: ${snapshot.error}'), // Show error message in the center
                      );
                    } else if (snapshot.hasData) {
                      final rooms = snapshot.data!;
                      return ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final room = rooms[index];
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(room.roomName),
                                Text('Players: ${room.numberOfPlayers}/4'),
                              ],
                            ), // subtitle:
                            //     Text('Players: ${room.numberOfPlayers}/4'),
                            onTap: () {
                              // Navigate to the selected room
                              // Store the selected room ID when tapped
                              setState(() {
                                _selectedRoomId = room.roomId;
                              });
                            },
                          );
                        },
                      );
                    } else {
                      return SizedBox(); // Return an empty SizedBox if none of the above conditions are met
                    }
                  },
                ),
              ),
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  onPressed: _selectedRoomId != null
                      ? () {
                          final Map<String, dynamic> currentPlayer = {
                            'uid': settings.playerUID.value,
                            'name': settings.playerName.value,
                          };
                          FirebaseFirestore.instance
                              .collection('rooms')
                              .doc(_selectedRoomId)
                              .update({
                            'players': FieldValue.arrayUnion([currentPlayer])
                          }).then((_) {
                            print('Successfully joined room: $_selectedRoomId');
                            // Navigate to the selected room
                            GoRouter.of(context).go('/room/$_selectedRoomId');
                          }).catchError((error) {
                            print('Failed to join room: $error');
                          });
                        }
                      : null,
                  child: const Text('Join'),
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
  final int numberOfPlayers;

  Room(
      {required this.roomId,
      required this.roomName,
      required this.numberOfPlayers});

  factory Room.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Room(
      roomId: snapshot.id,
      roomName: data['roomName'] ?? '',
      numberOfPlayers: (data['players'] as List<dynamic>).length,
    );
  }
}
