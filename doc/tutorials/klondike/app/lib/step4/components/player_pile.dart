import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../klondike_game.dart';
import '../pile.dart';
import '../suit.dart';
import 'card.dart';
import 'deck_pile.dart';

class PlayerPile extends PositionComponent
    with TapCallbacks, HasGameRef<KlondikeGame>
    implements Pile {
  // static double get cardSpacingDown => 0.05;
  PlayerPile(int intSuit, {this.name = 'Unknown', super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: KlondikeGame.cardSize);
  final String name;
  final Suit suit;
  final List<Card> _cards = [];
  final Vector2 _fanOffset1 = Vector2(KlondikeGame.cardSpacingFaceDown, 0);
  final Vector2 _fanOffset2 = Vector2(0, KlondikeGame.cardSpacingFaceDown);

  final Vector2 _fanOffset3 = Vector2(-(KlondikeGame.cardSpacingFaceDown), 0);
  final Vector2 _fanOffset4 = Vector2(0, -(KlondikeGame.cardSpacingFaceDown));

  //#region Pile API
  double get getCardGap => 0.05;

  @override
  bool canMoveCard(Card card) {
    // this.
    // return _cards.isNotEmpty && card == _cards.last;
    return _cards.isNotEmpty && card.isFaceUp;
  }

  @override
  bool canAcceptCard(Card card) {
    return card.isFaceDown;
    // final topCardRank = _cards.isEmpty ? 0 : _cards.last.rank.value;
    // return card.suit == suit &&
    //     card.rank.value == topCardRank + 1 &&
    //     card.attachedCards.isEmpty;
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = _cards.indexOf(card);
  }

  @override
  void acquireCard(Card card) {
    if (name != 'SOUTH') {
      assert(card.isFaceDown);
    }
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
    layOutCards();
  }

  //#endregion

  //#region Rendering

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(KlondikeGame.cardWidth * 0.6),
      overridePaint: _suitPaint,
    );
  }

  //#endregion
  void layOutCards() {
    if (_cards.isEmpty) {
      return;
    }
    // reset bottom card position to be the same as pile
    _cards[0].position.setFrom(position);
    for (var i = 1; i < _cards.length; i++) {
      _cards[i].position
        ..setFrom(_cards[i - 1].position)
        // ..add(_cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
        ..add(getOffsetByPosition(name));
    }
    width = KlondikeGame.cardWidth * 1.5 + _cards.last.x - _cards.first.x;
  }

  Vector2 getOffsetByPosition(String position) {
    switch (position) {
      case 'SOUTH':
        return _fanOffset1;
      case 'NORTH':
        return _fanOffset3;
      case 'WEST':
        return _fanOffset2;
      case 'EAST':
        return _fanOffset4;
      // break;
      default:
    }
    return position == 'SOUTH' || name == 'NORTH' ? _fanOffset1 : _fanOffset2;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODONE: implement onTapUp
    final deck = parent!.firstChild<DeckPile>()!;
    print(
        'player tapped when game isDealing is ${game.isDealing} and deck is $deck');
    if (game.isDealing) {
      deck.dealTo(this);
    }

    super.onTapUp(event);
  }
}
