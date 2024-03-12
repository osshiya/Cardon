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

  String getActionDesc(CardSuit suit, int value) {
    switch (suit) {
      case CardSuit.energy:
        if (value == 0) {
          return 'Add 1 card to your hand for each player.';
        } else if (value == 1) {
          return 'Skip the next player\'s turn due to smooth operations.';
        } else if (value == 2) {
          return 'Add 2 cards to your hand for future investment.';
        } else if (value == 3) {
          return 'No effect for mutual benefit.';
        } else if (value == 4) {
          return 'Reverse the turn order to reflect mismanagement.';
        } else if (value == 5) {
          return 'Draw 2 additional cards due to reliance on fossil fuels.';
        } else if (value == 6) {
          return 'Skip the next player\'s turn to represent missed opportunities.';
        } else if (value == 7) {
          return 'Add 3 cards to your hand to compensate for setbacks.';
        } else if (value == 8) {
          return 'No effect to reflect loss of resources.';
        } else if (value == 9) {
          return 'Draw 2 additional cards due to environmental damage.';
        }
        break;
      case CardSuit.transportation:
        if (value == 0) {
          return 'Take another turn for promoting sustainable transportation.';
        } else if (value == 1) {
          return 'Add 1 card to your hand to reflect efficiency.';
        } else if (value == 2) {
          return 'No effect to encourage eco-friendly infrastructure.';
        } else if (value == 3) {
          return 'No effect to support public transit.';
        } else if (value == 4) {
          return 'Reverse the turn order due to increased emissions.';
        } else if (value == 5) {
          return 'Draw 2 additional cards due to lack of foresight.';
        } else if (value == 6) {
          return 'Skip the next player\'s turn to represent misplaced priorities.';
        } else if (value == 7) {
          return 'No effect to reflect congestion.';
        } else if (value == 8) {
          return 'Draw 3 additional cards due to transportation failure.';
        } else if (value == 9) {
          return 'Add 2 cards to your hand due to environmental impact.';
        }
        break;
      case CardSuit.industry:
        if (value == 0) {
          return 'No effect to reflect emissions reduction.';
        } else if (value == 1) {
          return 'Take another turn to promote sustainability.';
        } else if (value == 2) {
          return 'No effect for mutual benefit.';
        } else if (value == 3) {
          return 'Reverse the turn order due to environmental negligence.';
        } else if (value == 4) {
          return 'Skip the next player\'s turn to reflect reliance on polluting energy sources.';
        } else if (value == 5) {
          return 'Draw 2 additional cards due to lack of compliance.';
        } else if (value == 6) {
          return 'Add 2 cards to your hand to reflect environmental damage.';
        } else if (value == 7) {
          return 'Draw 2 additional cards due represent pollution.';
        } else if (value == 8) {
          return 'Draw 3 additional cards due to industrial mishaps.';
        } else if (value == 9) {
          return 'Skip the next player\'s turn due to environmental catastrophe.';
        }
        break;
      case CardSuit.agriculture:
        if (value == 0) {
          return 'Take another turn for sustainable farming practices.';
        } else if (value == 1) {
          return 'No effect to represent soil conservation.';
        } else if (value == 2) {
          return 'No effect to support organic farming.';
        } else if (value == 3) {
          return 'Reverse the turn order to reflect environmental degradation.';
        } else if (value == 4) {
          return 'Draw 2 additional cards due to reliance on harmful chemicals.';
        } else if (value == 5) {
          return 'Skip the next player\'s turn to represent environmental neglect.';
        } else if (value == 6) {
          return 'Add 1 cards to your hand represent habitat destruction.';
        } else if (value == 7) {
          return 'Add 2 cards to your hand to reflect ecological damage.';
        } else if (value == 8) {
          return 'Draw 3 additional cards due to agricultural collapse.';
        } else if (value == 9) {
          return 'Skip the next player\'s turn due to deforestation.';
        }
        break;
      case CardSuit.all:
        break;
    }
    // If no specific description is found, return an empty string
    return '';
  }

  List getAction(CardSuit suit, int value) {
    switch (suit) {
      case CardSuit.energy:
        if (value == 0) {
          return ['add', 1];
        } else if (value == 1) {
          return ['skip', 1];
        } else if (value == 2) {
          return ['add', 2];
        } else if (value == 3) {
          return ['none', 1];
        } else if (value == 4) {
          return ['reverse', 1];
        } else if (value == 5) {
          return ['add', 2];
        } else if (value == 6) {
          return ['skip', 1];
        } else if (value == 7) {
          return ['add', 3];
        } else if (value == 8) {
          return ['none', 2];
        } else if (value == 9) {
          return ['add', 2];
        }
        break;
      case CardSuit.transportation:
        if (value == 0) {
          return ['turn', 1];
        } else if (value == 1) {
          return ['add', 1];
        } else if (value == 2) {
          return ['none', 2];
        } else if (value == 3) {
          return ['none', 1];
        } else if (value == 4) {
          return ['reverse', 1];
        } else if (value == 5) {
          return ['add', 2];
        } else if (value == 6) {
          return ['skip', 1];
        } else if (value == 7) {
          return ['none', 2];
        } else if (value == 8) {
          return ['add', 3];
        } else if (value == 9) {
          return ['add', 2];
        }
        break;
      case CardSuit.industry:
        if (value == 0) {
          return ['none', 1];
        } else if (value == 1) {
          return ['turn', 1];
        } else if (value == 2) {
          return ['none', 1];
        } else if (value == 3) {
          return ['reverse', 1];
        } else if (value == 4) {
          return ['skip', 1];
        } else if (value == 5) {
          return ['add', 2];
        } else if (value == 6) {
          return ['add', 2];
        } else if (value == 7) {
          return ['none', 2];
        } else if (value == 8) {
          return ['add', 3];
        } else if (value == 9) {
          return ['skip', 1];
        }
        break;
      case CardSuit.agriculture:
        if (value == 0) {
          return ['turn', 1];
        } else if (value == 1) {
          return ['none', 1];
        } else if (value == 2) {
          return ['none', 1];
        } else if (value == 3) {
          return ['reverse', 1];
        } else if (value == 4) {
          return ['add', 2];
        } else if (value == 5) {
          return ['skip', 1];
        } else if (value == 6) {
          return ['none', 2];
        } else if (value == 7) {
          return ['add', 2];
        } else if (value == 8) {
          return ['add', 3];
        } else if (value == 9) {
          return ['skip', 1];
        }
        break;
      case CardSuit.all:
        break;
    }
    // If no specific action is found, return an empty list
    return [];
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
