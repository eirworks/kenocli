import 'dart:io';

import 'game.dart';

void main() {
  print(GAME_NAME);
  print("Version ${Game.VERSION}");

  stdout.write("Your name: ");
  var name = stdin.readLineSync();
  final game = Game(name: name ?? "John");

  while (game.money > 0) {
    game.prompt();
  }

  print("Looks like you out of money, come back later!");
}
