import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/services.dart';

import 'components/card.dart';
import 'components/deck_pile.dart';
// import 'components/foundation_pile.dart';
import 'components/player_pile.dart';
// import 'components/stock_pile.dart';
// import 'components/tableau_pile.dart';
import 'components/trick_pile.dart';
import 'components/waste_pile.dart';

class KlondikeGame extends FlameGame with KeyboardEvents {
  static const double cardGap = 175.0;
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static const double gameWidth = cardWidth * 7 + cardGap * 8;
  static const double gameHeight = 4 * cardHeight + 3 * cardGap;
  static final Vector2 gameSize = Vector2(gameWidth, gameHeight);

  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );

  bool isDealing = false;

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        // print('letter D');
        isDealing = true;
        // square.moveLeft();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        // square.moveRight();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // square.moveUp();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // square.moveDown();
      }
    } else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        print('letter D up');
        isDealing = false;
      }
    }
    return KeyEventResult.handled;
  }

  @override
  Future<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');

    // final stock = StockPile(position: Vector2(cardGap, cardGap));
    final trickPile = TrickPile(
        position: Vector2(
            gameWidth / 2 - cardWidth / 2, gameHeight / 2 - cardHeight / 2));
    // final waste =
    // WastePile(position: Vector2(cardWidth + 2 * cardGap, cardGap));
    final playerPiles = List.generate(
      numberOfPlayers,
      (i) => PlayerPile(
        i,
        position: getPlayerPile(i),
      ),
    );
    // final piles = List.generate(
    //   7,
    //   (i) => TableauPile(
    //     position: Vector2(
    //       cardGap + i * (cardWidth + cardGap),
    //       cardHeight + 2 * cardGap,
    //     ),
    //   ),
    // );
    final deck =
        DeckPile(position: Vector2(cardGap, gameHeight - cardHeight - cardGap));

    final world = World()
          // ..add(stock)
          ..add(trickPile)
          ..addAll(playerPiles)
          ..add(deck)
        // ..addAll(piles)
        ;
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap)
      ..viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);

    // Function func = ;
    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit),
    ];
    cards.shuffle();
    world.addAll(cards);

    // for (var i = 0; i < 7; i++) {
    //   for (var j = i; j < 7; j++) {
    //     piles[j].acquireCard(cards.removeLast());
    //   }
    //   piles[i].flipTopCard();
    // }
    // cards.forEach(stock.acquireCard);
    cards.forEach(deck.acquireCard);
  }

  Vector2 getPlayerPile(int i) {
    switch (i) {
      case 0:

        /// player is west
        return Vector2(cardGap, gameHeight / 2 - cardHeight / 2);
      case 1:

        /// player is north
        return Vector2(gameWidth / 2 - cardWidth / 2, cardGap);
      case 2:

        /// player is east
        return Vector2(
            gameWidth - cardWidth - cardGap, gameHeight / 2 - cardHeight / 2);
      case 3:

        /// player is south
        return Vector2(
            gameWidth / 2 - cardWidth / 2, gameHeight - cardHeight - cardGap);
      default:
        return Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap);
    }
  }

  int get numberOfPlayers => 4;
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
