enum CardSuit {
  energy(1),
  transportation(2),
  industry(3),
  agriculture(4),
  ultimate(5);

  final int internalRepresentation;

  const CardSuit(this.internalRepresentation);

  String get asCharacter {
    switch (this) {
      case CardSuit.energy:
        return '⚡';
      case CardSuit.transportation:
        return '🚌';
      case CardSuit.industry:
        return '🏭';
      case CardSuit.agriculture:
        return '🌱';
      case CardSuit.ultimate:
        return '💣';
    }
  }

  CardSuitColor get color {
    switch (this) {
      case CardSuit.energy:
        return CardSuitColor.green;
      case CardSuit.transportation:
        return CardSuitColor.blue;
      case CardSuit.industry:
        return CardSuitColor.yellow;
      case CardSuit.agriculture:
        return CardSuitColor.red;
      case CardSuit.ultimate:
        return CardSuitColor.black;
    }
  }

  @override
  String toString() => asCharacter;
}

enum CardSuitColor { green, blue, yellow, red, black }
