import 'package:flame/components.dart';

class CollisionTile extends Component {
  final int tileId;
  final int tileX;
  final int tileY;
  final int tileWidth;
  final int tileHeight;

  late final Vector2 _position;
  late final Vector2 _size;

  CollisionTile({
    required this.tileId,
    required this.tileX,
    required this.tileY,
    required this.tileWidth,
    required this.tileHeight,
  }) {
    _position = Vector2(tileX * tileWidth.toDouble(), tileY * tileHeight.toDouble());
    _size = Vector2(tileWidth.toDouble(), tileHeight.toDouble());
  }

  Vector2 get position => _position;
  Vector2 get size => _size;
}
