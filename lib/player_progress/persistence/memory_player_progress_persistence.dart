// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:myapp/player_progress/persistence/player_progress_persistence.dart';

/// An in-memory implementation of [PlayerProgressPersistence].
/// Useful for testing.
class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  String room = '';

  @override
  Future<String> getLastRoomID() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return room;
  }

  @override
  Future<void> saveLastRoomID(String room) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.room = room;
  }
}
