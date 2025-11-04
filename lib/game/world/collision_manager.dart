import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../entities/collision_tile.dart';

class CollisionManager {
  static List<CollisionTile> createCollisionTilesFromLayer(
    TileLayer layer,
    int tileWidth,
    int tileHeight,
  ) {
    final collisionTiles = <CollisionTile>[];

    final data = layer.data;
    if (data == null) return collisionTiles;

    for (int y = 0; y < layer.height; y++) {
      for (int x = 0; x < layer.width; x++) {
        final tileId = data[y * layer.width + x];
        if (tileId > 0) {
          collisionTiles.add(
            CollisionTile(
              tileId: tileId,
              tileX: x,
              tileY: y,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
            ),
          );
        }
      }
    }

    return collisionTiles;
  }

  static bool checkCollision(Vector2 position, Vector2 size, List<CollisionTile> collisionTiles) {
    // With Anchor.bottomCenter, position refers to bottom center of character
    // Use smaller collision frame (70% of visual size) for better gameplay feel
    final collisionWidth = size.x * 0.7;
    final collisionHeight = size.y * 0.7;

    final playerRect = Rect.fromLTWH(
      position.x - collisionWidth / 2, // left edge
      position.y - collisionHeight, // top edge (smaller frame above position)
      collisionWidth, // smaller width
      collisionHeight, // smaller height
    );

    for (final tile in collisionTiles) {
      final tileRect = Rect.fromLTWH(tile.position.x, tile.position.y, tile.size.x, tile.size.y);

      if (playerRect.overlaps(tileRect)) {
        return true;
      }
    }

    return false;
  }
}
