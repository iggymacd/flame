import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:klondike/step4/components/deck_pile.dart';

import '../klondike_game.dart';
import '../pile.dart';
import '../suit.dart';
import 'card.dart';

class PlayerPile extends PositionComponent
    with TapCallbacks, HasGameRef<KlondikeGame>
    implements Pile {
  PlayerPile(int intSuit, {super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: KlondikeGame.cardSize);

  final Suit suit;
  final List<Card> _cards = [];
  final Vector2 _fanOffset1 = Vector2(KlondikeGame.cardWidth * 0.05, 0);

  //#region Pile API

  @override
  bool canMoveCard(Card card) {
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
    assert(card.isFaceDown);
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
        ..add(_fanOffset1);
    }
    width = KlondikeGame.cardWidth * 1.5 + _cards.last.x - _cards.first.x;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODONE: implement onTapUp
    final deck = parent!.firstChild<DeckPile>()!;
    print(
        'player tapped when game isDealing is ${game.isDealing} and deck is $deck');
    super.onTapUp(event);
  }
}
