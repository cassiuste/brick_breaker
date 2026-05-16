import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

import '../brick_breaker.dart';

class Bat extends SpriteComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({
    required super.sprite,
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center, children: [RectangleHitbox()]);

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
  }

  void moveBy(double dx) {
    add(
      MoveToEffect(
        Vector2((position.x + dx).clamp(0, game.width), position.y),
        EffectController(duration: 0.1),
      ),
    );
  }
}