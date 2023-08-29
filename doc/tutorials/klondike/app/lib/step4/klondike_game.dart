import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
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
  late final CameraComponent cameraComponent;
  static const double cardGap = 175.0;
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final Vector2 cardSizeHor = Vector2(cardHeight, cardWidth);
  static const double gameWidth = cardWidth * 7 + cardGap * 8;
  // static const double gameHeight = 4 * cardHeight + 3 * cardGap;
  static const double gameHeight = gameWidth;
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
    final isKeyDown = event is RawKeyDownEvent;

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
      } else if (event.logicalKey == LogicalKeyboardKey.keyI) {
        cameraComponent.viewfinder.zoom *= 2;
        // square.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.keyO) {
        cameraComponent.viewfinder.zoom /= 2;
        // square.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        // cameraComponent.viewfinder.anchor = Anchor.topCenter;
        // cameraComponent.viewfinder.visibleGameSize =
        //     Vector2(gameHeight, gameWidth);
        // cameraComponent.viewfinder.position =
        //     Vector2(gameHeight / 2, gameWidth / 2);
        cameraComponent.viewfinder.angle = radians(90);
        // cameraComponent.viewfinder.anchor = Anchor.topCenter;
        // square.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
        // cameraComponent.viewfinder.anchor = Anchor.bottomCenter;
        cameraComponent.viewfinder.angle = radians(180);
        // cameraComponent.viewfinder.visibleGameSize =
        //     Vector2(gameWidth, gameHeight);
        // cameraComponent.viewfinder.position =
        //     Vector2(gameWidth / 2, gameHeight / 2);
        // cameraComponent.viewfinder.anchor = Anchor.topCenter;
        // square.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        // cameraComponent.viewfinder.anchor = Anchor.bottomLeft;
        // cameraComponent.viewfinder.visibleGameSize =
        //     Vector2(gameHeight, gameWidth);
        // cameraComponent.viewfinder.position =
        //     Vector2(gameHeight / 2, gameWidth / 2);
        cameraComponent.viewfinder.angle = radians(270);
        // cameraComponent.viewfinder.anchor = Anchor.topCenter;
        // square.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        // cameraComponent.viewfinder.anchor = Anchor.topCenter;
        cameraComponent.viewfinder.angle = radians(0);
        // cameraComponent.viewfinder.visibleGameSize =
        //     Vector2(gameWidth, gameHeight);
        // cameraComponent.viewfinder.position =
        //     Vector2(gameWidth / 2, gameHeight / 2);
        // cameraComponent.viewfinder.anchor = Anchor.topCenter;
        // square.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {}
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

    var pressedTimes = 0;
    var releasedTimes = 0;
    var cancelledTimes = 0;
    // final initialGameSize = Vector2.all(200);
    final componentSize = Vector2.all(100);
    final buttonPosition = Vector2.all(100);
    late final ButtonComponent button;
    // game.onGameResize(initialGameSize);
    // await game.ensureAdd(
    final onPressed2 = () => pressedTimesDisplay();
    button = ButtonComponent(
      button: CircleComponent(radius: 40),
      // button: RectangleComponent(size: componentSize),
      onPressed: onPressed2,
      onReleased: () => releasedTimes++,
      onCancelled: () => cancelledTimes++,
      position: buttonPosition,
      size: componentSize,
    );
    // );

    // final stock = StockPile(position: Vector2(cardGap, cardGap));
    final trickPile = TrickPile(
        position: Vector2(
            gameWidth / 2 - cardWidth / 2, gameHeight / 2 - cardHeight / 2));
    // final waste =
    // WastePile(position: Vector2(cardWidth + 2 * cardGap, cardGap));
    final playerPiles = List.generate(numberOfPlayers, (i) {
      final pp = PlayerPile(
        i,
        // position: getPlayerPilePosition(i),
        name: getPositionName(i),
      );
      // if (i.isEven) {
      //   pp.anchor = Anchor.center;
      //   pp.angle = degrees2Radians * 90;
      // }
      pp.position = getPlayerPilePosition(i);
      return pp;
    }
        // ..anchor = Anchor.center
        // ..angle = i.isEven ? degrees2Radians * 90 : 0,
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
          ..add(button)
          ..add(trickPile)
          ..addAll(playerPiles)
          ..add(deck)
          ..debugMode = true
        // ..addAll(piles)
        ;
    add(world);

    cameraComponent = CameraComponent(world: world)
          // ..viewport.debugMode = true
          ..viewfinder.visibleGameSize = Vector2(gameWidth, gameHeight)
          // ..viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0)
          ..viewfinder.position = Vector2(gameWidth / 2, gameHeight / 2)
        // ..viewfinder.anchor = Anchor.center
        ;
    add(cameraComponent);

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

  Vector2 getPlayerPilePosition(int i) {
    switch (i) {
      case 0:

        /// player is west
        return Vector2(cardGap, gameHeight / 2 - cardWidth / 2);
      case 1:

        /// player is north
        return Vector2(gameWidth / 2 - cardWidth / 2, cardGap);
      case 2:

        /// player is east
        return Vector2(
            gameWidth - cardHeight - cardGap, gameHeight / 2 - cardWidth / 2);
      case 3:

        /// player is south
        return Vector2(
            gameWidth / 2 - cardWidth / 2, gameHeight - cardHeight - cardGap);
      default:
        return Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap);
    }
  }

  int get numberOfPlayers => 4;

  pressedTimesDisplay() {
    print('clicked!!!!!');
  }

  String getPositionName(int i) {
    switch (i) {
      case 0:

        /// player is west
        return 'WEST';
      case 1:

        /// player is north
        return 'NORTH';
      case 2:

        /// player is east
        return 'EAST';
      case 3:

        /// player is south
        return 'SOUTH';
      default:
        return 'Unknown';
    }
  }
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
