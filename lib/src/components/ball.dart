import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../brick_breaker.dart';
import 'bat.dart';
import 'brick.dart';
import 'play_area.dart';

class Ball extends SpriteComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required super.sprite,
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
         size: Vector2.all(radius * 2),
         anchor: Anchor.center,
         children: [CircleHitbox()],
       );

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        
        game.lives.value--;

        if (game.lives.value <= 0) {
          add(
            RemoveEffect(
              delay: 0.35,
              onComplete: () {                                    
                game.playState = PlayState.gameOver;
              },
            ),
          );                                          
        } else {
          position = game.size / 2;
          velocity.setValues(
            (game.rand.nextDouble() - 0.5) * game.width,
            game.height * 0.2,
          );
          velocity.normalize();
          velocity.scale(game.height / 4);
        }
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x =
          velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}