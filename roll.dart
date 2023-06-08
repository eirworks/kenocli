import 'bet.dart';

class Roll {
  final List<int> topNumbers;
  final List<int> bottomNumbers;

  static const MIDDLE = 811;
  static const NUMBERS = 20;
  static const NUMBER_MAX = 80;
  static const NUMBER_MIN = 1;

  Roll({
    required this.bottomNumbers,
    required this.topNumbers,
  });

  factory Roll.generate() {
    final nums = rollNumber();
    return Roll(
        topNumbers: nums.sublist(0, 10), bottomNumbers: nums.sublist(10));
  }

  static List<int> rollNumber() {
    List<int> numbers = [];
    for (int i = 1; i <= NUMBER_MAX; i++) {
      numbers.add(i);
    }

    numbers.shuffle();

    return numbers.take(NUMBERS).toList();
  }

  List<int> get numbers {
    return topNumbers + bottomNumbers;
  }

  int get total {
    int total = 0;
    for (int i = 0; i < topNumbers.length; i++) {
      total += topNumbers[i];
    }
    for (int i = 0; i < bottomNumbers.length; i++) {
      total += bottomNumbers[i];
    }
    return total;
  }

  int get dragon {
    return int.parse("$total".split('').reversed.toList()[1]);
  }

  int get tiger {
    return int.parse("$total".split('').reversed.toList()[0]);
  }

  bool get isDragonTigerTied => dragon == tiger;
  bool get isDragon => dragon > tiger;
  bool get isTiger => dragon < tiger;

  bool get isEven => total.isEven;
  bool get isOdd => total.isOdd;

  bool get isBig => total >= MIDDLE;
  bool get isSmall => total < MIDDLE;

  bool get isBigEven => isBig && isEven;
  bool get isBigOdd => isBig && isOdd;
  bool get isSmallOdd => isSmall && isOdd;
  bool get isSmallEven => isSmall && isEven;

  bool get isGold => calculateElement() == BettingType.gold;
  bool get isWood => calculateElement() == BettingType.wood;
  bool get isWater => calculateElement() == BettingType.water;
  bool get isFire => calculateElement() == BettingType.fire;
  bool get isEarth => calculateElement() == BettingType.earth;

  String get element => calculateElement().name.toUpperCase();
  BettingType get winElement => calculateElement();

  printNumbers() {
    print(topNumbers.map((e) => e.toString().padLeft(2, "0")).join("-"));
    print(bottomNumbers.map((e) => e.toString().padLeft(2, "0")).join("-"));
  }

  BettingType calculateElement() {
    if (total >= 210 && total <= 695) {
      return BettingType.gold;
    } else if (total >= 696 && total <= 763) {
      return BettingType.wood;
    } else if (total >= 764 && total <= 855) {
      return BettingType.water;
    } else if (total >= 856 && total <= 923) {
      return BettingType.fire;
    } else {
      return BettingType.earth;
    }
  }
}
