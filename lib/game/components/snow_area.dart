import 'package:flame_forge2d/flame_forge2d.dart';

class SnowArea extends BodyComponent {
  SnowArea({
    required this.areaCenter,
    required this.width,
    required this.height,
  });

  final Vector2 areaCenter;
  final double width;
  final double height;

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(width / 2, height / 2);
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true
      ..friction = 0.8;
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = areaCenter;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
