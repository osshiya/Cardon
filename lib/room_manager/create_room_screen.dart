// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:myapp/style/button.dart';
import 'package:myapp/style/palette.dart';
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
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    icon: Icon(Icons.settings, color: palette.blackPen),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Room',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Madimi One',
                        fontSize: 34,
                        color: palette.blackPen,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: palette.trueWhite,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _roomNameController,
                        style: TextStyle(color: palette.blackPen),
                        decoration: InputDecoration(
                          hintText: 'Enter room name',
                          hintStyle: TextStyle(
                              color: palette.blackPen.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                                      numberOfPlayers: 1,
                                    );
                                    final Map<String, dynamic> currentPlayer = {
                                      'uid': settings.playerUID.value,
                                      'name': settings.playerName.value,
                                    };
                                    FirebaseFirestore.instance
                                        .collection('rooms')
                                        .add({
                                      'roomName': newRoom.roomName,
                                      'players': FieldValue.arrayUnion(
                                          [currentPlayer]),
                                      'gameStarted': false
                                    }).then((value) {
                                      print(
                                          'Room created successfully: ${value.id}');
                                      _roomNameController.clear();
                                      GoRouter.of(context).go(
                                          '/room/${value.id}&${newRoom.roomName}');
                                    }).catchError((error) {
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
              ),
            ),
          ],
        ),
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
