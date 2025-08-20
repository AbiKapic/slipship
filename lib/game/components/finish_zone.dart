import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shipslip/game/components/player.dart';

class FinishZone extends BodyComponent with ContactCallbacks {
  FinishZone({
    required this.areaCenter,
    required this.radius,
    required this.onReached,
  });

  final Vector2 areaCenter;
  final double radius;
  final VoidCallback onReached;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true
      ..friction = 0.0;
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = areaCenter;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paintOuter = Paint()..color = const Color(0xFFFFA726);
    final paintInner = Paint()..color = const Color(0xFFFF7043);
    canvas.drawCircle(Offset.zero, radius, paintOuter);
    canvas.drawCircle(Offset(0, -radius * 0.4), radius * 0.6, paintInner);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      onReached();
    }
  }
}
