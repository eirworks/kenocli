import 'roll.dart';

enum BettingType {
  small,
  large,
  odd,
  even,
  smallOdd,
  largeOdd,
  smallEven,
  largeEven,
  tiger, // last digit
  dragon, // middle digit
  dragonTigerTie, // last digit = middle digit
  over,
  under,
  overUnderTie,

  gold,
  wood,
  water,
  fire,
  earth,
}

class Bet {
  final BettingType type;
  final int value;
  final double payout;

  Bet({required this.type, required this.value, required this.payout});

  factory Bet.make({required BettingType type, required int value}) {
    return Bet(type: type, value: value, payout: calculatePayout(type, value));
  }

  static double calculatePayout(BettingType type, int value) {
    final double rate = betRate()[type] ?? 1.0;
    return value * rate;
  }

  static Map<BettingType, double> betRate() {
    return {
      BettingType.small: 1.95,
      BettingType.large: 1.95,
      BettingType.even: 1.95,
      BettingType.odd: 1.95,

      // combination
      BettingType.smallEven: 3.70,
      BettingType.smallOdd: 3.70,
      BettingType.largeEven: 3.70,
      BettingType.largeOdd: 3.70,

      // dragon and tiger
      BettingType.dragon: 1.95,
      BettingType.tiger: 1.95,
      BettingType.dragonTigerTie: 9.0,

      BettingType.over: 2.30,
      BettingType.under: 2.30,
      BettingType.overUnderTie: 4.30,

      BettingType.gold: 9.20,
      BettingType.wood: 4.60,
      BettingType.water: 2.40,
      BettingType.fire: 4.60,
      BettingType.earth: 9.20,
    };
  }

  static double betTypeRate(BettingType type) {
    return betRate()[type] ?? 1.0;
  }

  double win(Roll roll) {
    return isWin(roll) ? value.toDouble() : 0.0;
  }

  bool isWin(Roll roll) {
    Map<BettingType, Function> funcs = {
      BettingType.large: (Roll roll) {
        return roll.isBig;
      },
      BettingType.small: (Roll roll) {
        return roll.isSmall;
      },
      BettingType.even: (Roll roll) {
        return roll.isEven;
      },
      BettingType.odd: (Roll roll) {
        return roll.isOdd;
      },
      BettingType.dragon: (Roll roll) {
        return roll.isDragon;
      },
      BettingType.tiger: (Roll roll) {
        return roll.isTiger;
      },
      BettingType.dragonTigerTie: (Roll roll) {
        return roll.isDragonTigerTied;
      },
      BettingType.largeEven: (Roll roll) {
        return roll.isBigEven;
      },
      BettingType.largeOdd: (Roll roll) {
        return roll.isBigOdd;
      },
      BettingType.smallEven: (Roll roll) {
        return roll.isSmallEven;
      },
      BettingType.smallOdd: (Roll roll) {
        return roll.isSmallOdd;
      },
      BettingType.gold: (Roll roll) {
        return roll.isGold;
      },
      BettingType.wood: (Roll roll) {
        return roll.isWood;
      },
      BettingType.water: (Roll roll) {
        return roll.isWater;
      },
      BettingType.fire: (Roll roll) {
        return roll.isFire;
      },
      BettingType.earth: (Roll roll) {
        return roll.isEarth;
      },
    };

    if (funcs.containsKey(type)) {
      return funcs[type]!(roll);
    } else {
      return false;
    }
  }
}
