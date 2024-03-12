// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

import 'package:myapp/player_progress/persistence/player_progress_persistence.dart';

/// An implementation of [PlayerProgressPersistence] that uses
/// `package:shared_preferences`.
class LocalStoragePlayerProgressPersistence extends PlayerProgressPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<String> getLastRoomID() async {
    final prefs = await instanceFuture;
    return prefs.getString('lastRoomID') ?? '';
  }

  @override
  Future<void> saveLastRoomID(String room) async {
    final prefs = await instanceFuture;
    await prefs.setString('lastRoomID', room);
  }
}
