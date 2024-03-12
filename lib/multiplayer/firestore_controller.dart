import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:myapp/game_internals/board_state.dart';
import 'package:myapp/game_internals/playing_area.dart';
import 'package:myapp/game_internals/playing_card.dart';
import 'package:myapp/player_progress/player_progress.dart';

// Cards on the deck
// Player's Card, Other's player card count
// Timer (Start time)
// Current player

class FirestoreController {
  static final _log = Logger('FirestoreController');

  final FirebaseFirestore instance;

  final BoardState boardState;

  final PlayerProgress playerProgress;

  /// For now, there is only one match. But in order to be ready
  /// for match-making, put it in a Firestore collection called matches.
  late final _matchRef =
      instance.collection('rooms').doc(playerProgress.lastRoomId);

  late final _playingAreaRef = _matchRef.withConverter<List<PlayingCard>>(
      fromFirestore: _cardsFromFirestore, toFirestore: _cardsToFirestore);

  StreamSubscription? _playingAreaFirestoreSubscription;

  StreamSubscription? _playingAreaLocalSubscription;

  FirestoreController(
      {required this.instance,
      required this.boardState,
      required this.playerProgress}) {
    // Subscribe to the remote changes (from Firestore).
    _playingAreaFirestoreSubscription =
        _playingAreaRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.playingArea, snapshot);
    });
    // _playerAreaFirestoreSubscription =
    //     _playerAreaRef.snapshots().listen((snapshot) {
    //   _updateLocalFromFirestore(boardState.playingArea, snapshot);
    // });

    // Subscribe to the local changes in game state.
    _playingAreaLocalSubscription =
        boardState.playingArea.playerChanges.listen((_) {
      _updateFirestoreFromLocalPlayingArea();
    });
    // _playerAreaLocalSubscription =
    //     boardState.playerArea.playerChanges.listen((_) {
    //   _updateFirestoreFromLocalPlayerArea();
    // });

    _log.fine('Initialized');
  }

  void dispose() {
    _playingAreaFirestoreSubscription?.cancel();
    // _areaTwoFirestoreSubscription?.cancel();
    _playingAreaLocalSubscription?.cancel();
    // _areaTwoLocalSubscription?.cancel();

    _log.fine('Disposed');
  }

  /// Takes the raw JSON snapshot coming from Firestore and attempts to
  /// convert it into a list of [PlayingCard]s.
  List<PlayingCard> _cardsFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?['cards'] as List?;

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      return [];
    }

    final list = List.castFrom<Object?, Map<String, Object?>>(data);

    try {
      return list.map((raw) => PlayingCard.fromJson(raw)).toList();
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to parse data from Firestore: $e');
    }
  }

  /// Takes a list of [PlayingCard]s and converts it into a JSON object
  /// that can be saved into Firestore.
  Map<String, Object?> _cardsToFirestore(
    List<PlayingCard> cards,
    SetOptions? options,
  ) {
    return {'cards': cards.map((c) => c.toJson()).toList()};
  }

  /// Updates Firestore with the local state of [area].
  void _updateFirestoreFromLocal(
      PlayingArea area, DocumentReference<List<PlayingCard>> ref) async {
    try {
      _log.fine('Updating Firestore with local data (${area.cards}) ...');
      await ref.set(area.cards, SetOptions(merge: true));
      _log.fine('... done updating.');
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to update Firestore with local data (${area.cards}): $e');
    }
  }

  /// Sends the local state of [boardState.playingArea] to Firestore.
  void _updateFirestoreFromLocalPlayingArea() {
    _updateFirestoreFromLocal(boardState.playingArea, _playingAreaRef);
  }

  // /// Sends the local state of [boardState.areaTwo] to Firestore.
  // void _updateFirestoreFromLocalAreaTwo() {
  //   _updateFirestoreFromLocal(boardState.areaTwo, _areaTwoRef);
  // }

  /// Updates the local state of [area] with the data from Firestore.
  void _updateLocalFromFirestore(
      PlayingArea area, DocumentSnapshot<List<PlayingCard>> snapshot) {
    _log.fine('Received new data from Firestore (${snapshot.data()})');

    final cards = snapshot.data() ?? [];

    if (listEquals(cards, area.cards)) {
      _log.fine('No change');
    } else {
      _log.fine('Updating local data with Firestore data ($cards)');
      area.replaceWith(cards);
    }
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
