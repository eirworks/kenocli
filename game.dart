import 'dart:io';

import 'bet.dart';
import 'roll.dart';
import 'winning.dart';

const SLOT_NUMBERS = 20;
const MAX_NUMBERS = 70;
const BETTING_MIN = 5;
const BIG_SMALL_LIMIT = 811;
const GAME_NAME = "KENO - Big Ball!";

class Game {
  static const VERSION = "1.0.0";
  final String name;
  double money = 100;
  double bet = 5;
  int rolls = 0;
  List<Bet> bets = [];
  Map<String, int> settings = {};

  Roll rollNumber = Roll.generate();

  Game({required this.name});

  List<int> get numbers => rollNumber.numbers;
  int total() => rollNumber.total;

  printScore() {
    if (rolls < 1) {
      print("We haven't roll anything yet");
    } else {
      rollNumber.printNumbers();
      print("Total: ${rollNumber.total}");
      print("Big/Small: ${rollNumber.isBig ? "Big" : "Small"}");
      print("Odd/Even: ${rollNumber.isEven ? "Even" : "Odd"}");
      print(
          "Dragon: ${rollNumber.dragon} | Tiger: ${rollNumber.tiger} | Tie: ${rollNumber.isDragonTigerTied ? 'Yes' : 'No'}");
      print("Five Element: ${rollNumber.element}");
      print("Rolls: $rolls");
    }
  }

  prompt() {
    print("$name | \$$money");
    stdout.write("> ");
    final cmd = stdin.readLineSync()?.toLowerCase();

    if (cmd == "help") {
      helpMsg();
    } else if (["quit", "exit", "q"].contains(cmd)) {
      print("Bye!");
      exit(0);
    } else if (["score"].contains(cmd)) {
      printScore();
    } else if (["roll"].contains(cmd)) {
      roll();
    } else if (cmd?.isEmpty ?? false) {
      print("Please type something or 'help' to get some help.");
    } else if (cmd == "bet") {
      bettingPhase();
    } else {
      print("I don't know '$cmd' command. Get some 'help'.");
    }
  }

  helpMsg() {
    print("- HELP: This help message");
    print("- QUIT: Exit this game");
    print("- ROLL: Roll the number and calculate your bettings");
    print("- SCORE: Display last roll and other scores");
    print("- BET: Setup betting for this round");
  }

  roll() {
    if (bets.isEmpty) {
      print("You didn't bet this roll");
    }
    rollingNumbers();
    printScore();
    final Winning win = calculateWinnings();
    if (win.winning > 0) {
      print("Congratulations! You win \$${win.winning}");
      // return payout and give the winnings
      money += (win.winning + win.payout);
    } else {
      print("You didn't win anything");
    }
    bets.clear();
  }

  rollingNumbers() {
    rollNumber = Roll.generate();
    rolls++;
  }

  bettingPhase() {
    print("--- BETTING PHASE ---");
    print("Type 'done' to return to the main game");
    final List<String> bettingCommands =
        BettingType.values.map((e) => e.name.toLowerCase()).toList();
    final Map<BettingType, String> bettingCommandMap = {};
    BettingType.values.forEach((element) {
      bettingCommandMap[element] = element.name;
    });

    while (true) {
      stdout.write("betphase \$$money> ");
      final betCmd = stdin.readLineSync()?.toLowerCase();

      if (["q", "quit", "exit"].contains(betCmd)) {
        print("--- BETTING PHASE END ---");
        break;
      } else if (betCmd == "bets") {
        displayBets();
      } else if (betCmd == "help") {
        betHelp(bettingCommandMap);
      } else if (bettingCommands.contains(betCmd)) {
        betting(betCmd ?? "");
      } else if (betCmd == "clear") {
        bets.clear();
        print("All bets cleared!");
      } else if (["rate", "rates"].contains(betCmd)) {
        displayRates();
      } else {
        if ((betCmd ?? "").isNotEmpty) {
          print("Unknown betting command: '$betCmd'");
        } else {
          print("Please type a bet command. Type 'help' for info");
        }
      }
    }
  }

  displayRates() {
    Bet.betRate().forEach((key, value) {
      print("-- ${key.name.toUpperCase()}: $value");
    });
  }

  displayBets() {
    if (bets.isEmpty) {
      print("You didn't have any bets");
    } else {
      bets.forEach((element) {
        print(
            "Betting for ${element.type.name.toUpperCase()} with value \$${element.value}");
      });
    }
  }

  Winning calculateWinnings() {
    double totalWinning = 0;
    double totalPayouts = 0;
    if (bets.isEmpty) {
      print("No bets");
    } else {
      bets.forEach((element) {
        if (element.isWin(rollNumber)) {
          final winningValue = element.payout - element.value;
          totalWinning += winningValue;
          totalPayouts += element.payout;
          print(
              "Bet ${element.type.name.toUpperCase()} is won! You received \$${winningValue}");
        } else {
          print("Bet ${element.type.name.toUpperCase()} is lost!");
        }
      });
    }

    return Winning(payout: totalPayouts, winning: totalWinning);
  }

  betting(String betCmd) {
    final BettingType type = BettingType.values.byName(betCmd);
    print("Betting $betCmd with rate ${Bet.betTypeRate(type)}");
    final existingBets = bets.where((element) => element.type == type).toList();
    if (existingBets.isNotEmpty) {
      print("You already bet ${betCmd} for ${existingBets.first.value}");
      return;
    }
    stdout.write("Amount \$:");
    final int amount = int.parse(stdin.readLineSync() ?? "0");
    if (amount > 0 && (amount % BETTING_MIN == 0)) {
      final double payout = Bet.calculatePayout(type, amount);
      print("Payout for \$$amount is \$$payout");
      if (money < payout) {
        print("You don't have enough money for payout (\$$payout)");
        return;
      }
      money -= payout;
      bets.add(Bet.make(type: type, value: amount));
      print("Bet added for ${type.name} for amount \$$amount!");
    } else {
      print("Amount must be multiple of ${BETTING_MIN}!");
    }
  }

  betHelp(Map<BettingType, String> bettingCommandMap) {
    print("- HELP : Show this betting help message");
    print("- DONE : Complete betting phase");
    bettingCommandMap.forEach((key, c) {
      print(
          "- ${c.toUpperCase()} : Betting for ${c.toUpperCase()} with rate ${Bet.betRate()[key]}");
    });
  }
}
