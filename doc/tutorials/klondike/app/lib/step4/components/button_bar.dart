import 'dart:async';

import 'package:flame/components.dart';

import '../klondike_game.dart';

class ButtonBarComponent extends RectangleComponent {
  late List<PositionComponent> _buttonList;
  final Vector2 _fanOffset1 = Vector2(KlondikeGame.cardGap / 2, 0);

  @override
  FutureOr<void> add(Component component) {
    // TODO: implement add
    _buttonList.add(component as PositionComponent);
    super.add(component);

    /// after adding component, layoutChildren
    layoutChildren();
  }

  void layoutChildren() {
    if (_buttonList.isEmpty) {
      return;
    }
    for (var i = 0; i < _buttonList.length; i++) {
      // _buttonList[i].position = Vector2.all(KlondikeGame.cardGap / 2);
      _buttonList[i].position
        ..setFrom(_buttonList[i - 1].position)
        ..add(_fanOffset1);
    }
  }
}
