import 'dart:math';

int randomBetween(int min, int max) {
  if (min >= max) {
    throw "Min must be lower than max!";
  }

  Random random = Random();

  return random.nextInt(max) + min;
}
