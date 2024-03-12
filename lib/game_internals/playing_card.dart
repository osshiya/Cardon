import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:myapp/game_internals/card_suit.dart';

@immutable
class PlayingCard {
  static final _random = Random();

  final CardSuit suit;

  final int value;

  const PlayingCard(this.suit, this.value);

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      CardSuit.values
          .singleWhere((e) => e.internalRepresentation == json['suit']),
      json['value'] as int,
    );
  }

  factory PlayingCard.random([Random? random]) {
    random ??= _random;
    var availableSuits =
        CardSuit.values.where((suit) => suit != CardSuit.all).toList();
    return PlayingCard(
      availableSuits[random.nextInt(availableSuits.length)],
      0 + random.nextInt(10),
    );
  }

  String getDesc(CardSuit suit, int value) {
    switch (suit) {
      case CardSuit.energy:
        if (value == 0) {
          return 'Generating electricity from solar panels.';
        } else if (value == 1) {
          return 'Regular maintenance of wind turbines.';
        } else if (value == 2) {
          return 'Constructing new solar farms.';
        } else if (value == 3) {
          return 'Upgrading solar panels for better efficiency.';
        } else if (value == 4) {
          return 'Inefficient use of renewable energy subsidies.';
        } else if (value == 5) {
          return 'Using diesel generators as backup for solar power.';
        } else if (value == 6) {
          return 'Ignoring potential for wind farm development.';
        } else if (value == 7) {
          return 'Halting funding for new renewable projects.';
        } else if (value == 8) {
          return 'Decommissioning existing wind farms due to lack of support.';
        } else if (value == 9) {
          return 'Massive reliance on coal due to failed renewable projects.';
        }
        break;
      case CardSuit.transportation:
        if (value == 0) {
          return 'Commuting via electric vehicle.';
        } else if (value == 1) {
          return 'Regular maintenance of hybrid cars.';
        } else if (value == 2) {
          return 'Building bike lanes in cities.';
        } else if (value == 3) {
          return 'Subsidizing public transportation.';
        } else if (value == 4) {
          return 'Increased reliance on gas-guzzling SUVs.';
        } else if (value == 5) {
          return 'Ignoring investments in electric vehicle infrastructure.';
        } else if (value == 6) {
          return 'Expanding highways instead of investing in public transit.';
        } else if (value == 7) {
          return 'Traffic congestion due to inadequate public transportation.';
        } else if (value == 8) {
          return 'Collapse of public transit systems due to lack of funding.';
        } else if (value == 9) {
          return 'Widespread use of inefficient, polluting vehicles.';
        }
        break;
      case CardSuit.industry:
        if (value == 0) {
          return 'Implementing carbon capture technology in factories.';
        } else if (value == 1) {
          return 'Recycling waste materials in manufacturing.';
        } else if (value == 2) {
          return 'Upgrading machinery for energy efficiency.';
        } else if (value == 3) {
          return 'Expanding manufacturing output without considering emissions.';
        } else if (value == 4) {
          return 'Reliance on coal-fired power for industrial processes.';
        } else if (value == 5) {
          return 'Ignoring emissions reduction targets in industry.';
        } else if (value == 6) {
          return 'Opening new factories without environmental assessments.';
        } else if (value == 7) {
          return 'Pollution of waterways due to lax industrial regulations.';
        } else if (value == 8) {
          return 'Closure of factories due to environmental disasters.';
        } else if (value == 9) {
          return 'Extensive pollution from industrial waste dumping.';
        }
        break;
      case CardSuit.agriculture:
        if (value == 0) {
          return 'Implementing no-till farming methods.';
        } else if (value == 1) {
          return 'Rotating crops to improve soil health.';
        } else if (value == 2) {
          return 'Using natural fertilizers like compost.';
        } else if (value == 3) {
          return 'Clearing forests for monoculture farming.';
        } else if (value == 4) {
          return 'Reliance on chemical fertilizers and pesticides.';
        } else if (value == 5) {
          return 'Ignoring soil erosion in agricultural practices.';
        } else if (value == 6) {
          return 'Expanding agricultural land into sensitive ecosystems.';
        } else if (value == 7) {
          return 'Loss of biodiversity due to monoculture farming.';
        } else if (value == 8) {
          return 'Abandoning farmland due to soil degradation.';
        } else if (value == 9) {
          return 'Widespread deforestation for agricultural expansion.';
        }
        break;
      case CardSuit.all:
        break;
    }
    // If no specific description is found, return an empty string
    return '';
  }

  @override
  int get hashCode => Object.hash(suit, value);

  @override
  bool operator ==(Object other) {
    return other is PlayingCard && other.suit == suit && other.value == value;
  }

  Map<String, dynamic> toJson() => {
        'suit': suit.internalRepresentation,
        'value': value,
      };

  @override
  String toString() {
    return '$suit$value';
  }
}
