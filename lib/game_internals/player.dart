import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/settings/settings.dart';
import 'package:provider/provider.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const initialCards = 7;
  static const newCard = 1;

  late List currentPlayers;

  Player({required this.currentPlayers});
  
  factory Player.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // Access the currentPlayer field from the snapshot data
    List currentPlayers = snapshot.get('currentPlayers');
    
    // Return a new Player object with the currentPlayer field set
    return Player(currentPlayers: currentPlayers);
  }

  final List<PlayingCard> hand =
      List.generate(initialCards, (index) => PlayingCard.random());

  void removeCard(PlayingCard card) {
    hand.remove(card);
    notifyListeners();
  }

  void addCard() {
    hand.add(PlayingCard.random());
    notifyListeners();
  }
}
