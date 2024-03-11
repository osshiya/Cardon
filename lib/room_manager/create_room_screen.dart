// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sfx.dart';
import '../game_internals/score.dart';
// import '../multiplayer/old_firestore_controller.dart';
import '../style/button.dart';
import '../style/palette.dart';

import 'package:myapp/settings/settings.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();

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
              const Spacer(),
              // The actual UI of the game.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _roomNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter room name',
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _roomNameController,
                  builder: (context, roomNameValue, child) {
                    return MyButton(
                      onPressed: roomNameValue.text.isNotEmpty
                          ? () {
                              // Create a new room and add it to Firebase
                              final newRoom = Room(
                                roomId: '',
                                roomName: roomNameValue.text,
                                numberOfPlayers:
                                    1, // Assuming the creator joins the room initially
                              );
                              final Map<String, dynamic> currentPlayer = {
                                'uid': settings.playerUID.value,
                                'name': settings.playerName.value,
                              };
                              FirebaseFirestore.instance
                                  .collection('rooms')
                                  .add({
                                'roomName': newRoom.roomName,
                                'players':
                                    FieldValue.arrayUnion([currentPlayer]),
                                'gameStarted': false
                              }).then((value) {
                                // Successfully created room
                                print('Room created successfully: ${value.id}');
                                _roomNameController.clear();
                                GoRouter.of(context).go('/room/${value.id}');
                              }).catchError((error) {
                                // Error occurred while creating room
                                print('Failed to create room: $error');
                              });
                            }
                          : null,
                      child: const Text('Join'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
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
