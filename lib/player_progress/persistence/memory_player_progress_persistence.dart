// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:myapp/player_progress/persistence/player_progress_persistence.dart';

/// An in-memory implementation of [PlayerProgressPersistence].
/// Useful for testing.
class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  String roomId = '';
  String roomName = '';

  @override
  Future<String> getLastRoomID() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return roomId;
  }

  @override
  Future<void> saveLastRoomID(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.roomId = roomId;
  }

  @override
  Future<String> getLastRoomName() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return roomName;
  }

  @override
  Future<void> saveLastRoomName(String roomName) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.roomName = roomName;
  }
}
