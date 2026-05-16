import 'dart:async';

import 'package:flame/collisions.dart';                         
import 'package:flame/components.dart';

import '../brick_breaker.dart';

class PlayArea extends SpriteComponent with HasGameReference<BrickBreaker> {
 PlayArea({required super.sprite})
    : super(
        children: [RectangleHitbox()],
      );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}