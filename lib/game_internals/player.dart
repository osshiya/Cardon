import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const initialCards = 7;
  static const newCard = 1;

  late String currentPlayer;

  Player({required this.currentPlayer});
  
  factory Player.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // Access the currentPlayer field from the snapshot data
    String currentPlayer = snapshot.get('currentPlayer');
    // Return a new Player object with the currentPlayer field set
    return Player(currentPlayer: currentPlayer);
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
