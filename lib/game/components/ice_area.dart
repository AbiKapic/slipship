import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shipslip/game/components/player.dart';

class IceArea extends BodyComponent with ContactCallbacks {
  IceArea({
    required this.areaCenter,
    required this.width,
    required this.height,
  });

  final Vector2 areaCenter;
  final double width;
  final double height;

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.setAsBoxXY(width / 2, height / 2);
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true
      ..friction = 0.0;
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = areaCenter;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      other.setOnIce(true);
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is Player) {
      other.setOnIce(false);
    }
  }
}
