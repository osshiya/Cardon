// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:myapp/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'package:myapp/player_progress/persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  /// By default, settings are persisted using
  /// [LocalStoragePlayerProgressPersistence] (i.e. NSUserDefaults on iOS,
  /// SharedPreferences on Android or local storage on the web).
  final PlayerProgressPersistence _store;

  String _lastRoomId = '';
  String _lastRoomName = '';

  /// Creates an instance of [PlayerProgress] backed by an injected
  /// persistence [store].
  PlayerProgress({PlayerProgressPersistence? store})
      : _store = store ?? LocalStoragePlayerProgressPersistence() {
    _getLatestFromStore();
  }

  /// The last room that the player has played so far.
  String get lastRoomId => _lastRoomId;
  String get lastRoomName => _lastRoomName;

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void reset() {
    _lastRoomId = '';
    _lastRoomName = '';
    notifyListeners();
    _store.saveLastRoomID(_lastRoomId);
    _store.saveLastRoomName(_lastRoomName);
  }

  /// Registers [level] as reached.
  ///
  /// If this is higher than [highestLevelReached], it will update that
  /// value and save it to the injected persistence store.
  void setLastRoomID(String room) {
    _lastRoomId = room;
    notifyListeners();

    unawaited(_store.saveLastRoomID(room));
  }

  void setLastRoomName(String room) {
    _lastRoomName = room;
    notifyListeners();

    unawaited(_store.saveLastRoomName(room));
  }

  /// Fetches the latest data from the backing persistence store.
  Future<void> _getLatestFromStore() async {
    final roomId = await _store.getLastRoomID();
    if (_lastRoomId == '') {
      _lastRoomId = roomId;
      notifyListeners();
    }
    final roomName = await _store.getLastRoomName();
    if (_lastRoomName == '') {
      _lastRoomName = roomName;
      notifyListeners();
    }
  }
}
