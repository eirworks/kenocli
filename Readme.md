# KENO CLI

A game of KENO based on real gambling game.

This game developed on Linux therefore the build system
only support linux.

## Running

To run the source immediatelly call this command:

```
dart run main.dart
```

## Compile

To build into executable:

```
make
```

## How Winning calculated

Each betting has their own rate. For example, betting on "even" has rate 1.92.
When betting, player will be charged with payout. Payout can be calculated with
this formula:

```
payout = bet * rate
```
In case you bet for even number with $5. Your money will be deducted by payout: `1.92 * 5 = 9.75`.

When you win, you will receive all the payout and payout - bet.

```
winning payment = payout + (payout - bet)
```