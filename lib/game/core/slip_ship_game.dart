import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../world/collision_manager.dart';
import '../entities/collision_tile.dart';
import '../entities/kid.dart';
import '../ui/directional_pad.dart';

class SlipShipGame extends FlameGame with HasCollisionDetection {
  @override
  late final World world;
  late final CameraComponent cam;

  late final TiledComponent level;
  late final Kid player;
  late final List<CollisionTile> collisionTiles;
  late final DirectionalPad dPad;

  // Movement smoothing
  final Vector2 _velocity = Vector2.zero();
  final double _accel = 900; // px/s^2
  final double _decel = 1400; // px/s^2

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1) World + Camera setup
    world = World();
    cam = CameraComponent(world: world)
      ..viewfinder.anchor = const Anchor(0.5, 0.62); // Breathing room above character

    addAll([world, cam]);

    // 2) Load TMX map
    // Tiled Map Layering: Set layer priorities in Tiled editor
    // - Background layers (ground, decorations): priority 0
    // - Foreground layers (walls, overlays): priority 20
    // - Player draws at priority 10 (between background and foreground)
    level = await TiledComponent.load('slip_ship_map.tmx', Vector2(44, 44));
    world.add(level);

    // 3) Create collision tiles from non-ground layers
    collisionTiles = <CollisionTile>[];
    final tileLayers = level.tileMap.map.layers.whereType<TileLayer>();

    for (final layer in tileLayers) {
      if (layer.name != 'ground') {
        final layerCollisions = CollisionManager.createCollisionTilesFromLayer(
          layer,
          44, // tileWidth
          44, // tileHeight
        );
        collisionTiles.addAll(layerCollisions);
        world.addAll(layerCollisions);
      }
    }

    // 4) Create player at center bottom of map
    final mapWidth = 15 * 44.0; // 660 pixels
    final mapHeight = 40 * 44.0; // 1760 pixels
    // With Anchor.bottomCenter, position refers to feet of character
    player = Kid()..position = Vector2(mapWidth / 2, mapHeight - 24); // Feet positioned near bottom
    world.add(player);

    // 5) Set camera to look at player position
    cam.moveTo(player.position.clone());

    // 6) Camera follows player
    cam.follow(player, maxSpeed: 300);

    // 7) Add Directional Pad as HUD (fixed to viewport) - positioned at bottom-left
    dPad = DirectionalPad()
      ..priority = 1000;

    // Attach to camera viewport so it stays pinned to screen
    cam.viewport.add(dPad);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Determine input direction and target speed
    Vector2 inputDir = Vector2.zero();
    double targetSpeed = 0;

    final dPadDirection = dPad.direction;
    if (dPadDirection.length2 > 0) {
      inputDir = dPadDirection;
      targetSpeed = player.speed;
    }

    // Update velocity with acceleration/deceleration
    if (inputDir.length2 > 0) {
      final desiredVel = inputDir * targetSpeed;
      final deltaVel = desiredVel - _velocity;
      final maxChange = _accel * dt;
      if (deltaVel.length <= maxChange) {
        _velocity.setFrom(desiredVel);
      } else {
        _velocity.add(deltaVel.normalized() * maxChange);
      }
    } else if (_velocity.length2 > 0) {
      // Apply friction
      final speed = _velocity.length;
      final drop = _decel * dt;
      final newSpeed = (speed - drop).clamp(0, double.infinity);
      if (newSpeed == 0) {
        _velocity.setZero();
      } else {
        _velocity.scale(newSpeed / speed);
      }
    }

    // Move with simple axis resolution to reduce corner sticking
    if (_velocity.length2 > 0) {
      final dx = _velocity.x * dt;
      final dy = _velocity.y * dt;

      // Try X axis
      var candidate = Vector2(player.position.x + dx, player.position.y);
      if (!CollisionManager.checkCollision(candidate, player.size, collisionTiles)) {
        player.position.x = candidate.x;
      } else {
        _velocity.x = 0; // stop X on collision
      }

      // Try Y axis
      candidate = Vector2(player.position.x, player.position.y + dy);
      if (!CollisionManager.checkCollision(candidate, player.size, collisionTiles)) {
        player.position.y = candidate.y;
      } else {
        _velocity.y = 0; // stop Y on collision
      }

      // Keep player within map bounds (bottomCenter anchor)
      final mapWidth = 15 * 44.0;
      final mapHeight = 40 * 44.0;
      final playerHalfWidth = player.size.x / 2;

      player.position.x = player.position.x
          .clamp(playerHalfWidth, mapWidth - playerHalfWidth)
          .toDouble();
      player.position.y = player.position.y.clamp(player.size.y, mapHeight).toDouble();
    }

    // Animation direction
    if (dPadDirection.length2 > 0) {
      player.setDirection(dPadDirection);
    } else if (_velocity.length2 > 0) {
      player.setDirection(_velocity);
    } else {
      player.setDirection(Vector2.zero());
    }

    // Position joystick at bottom-left
    final viewportSize = cam.viewport.size;
    final centerY = dPad.buttonSize + dPad.padding;
    final joystickHeight = centerY * 2 + dPad.buttonSize;
    dPad.position = Vector2(20, viewportSize.y - joystickHeight - 20);

    // Keep camera within map bounds to prevent black screens
    final mapWidth = 15 * 44.0;
    final mapHeight = 40 * 44.0;
    final anchor = cam.viewfinder.anchor;

    // Adjust camera position when moving up to keep player visible
    // Calculate where player appears on screen based on anchor
    if (_velocity.y < 0) {
      final anchorScreenY = anchor.y * viewportSize.y;
      final playerOffsetFromCamera = player.position.y - cam.viewfinder.position.y;
      final playerScreenY = anchorScreenY + playerOffsetFromCamera;
      final minVisibleY = 100.0;
      
      if (playerScreenY < minVisibleY) {
        final adjustment = minVisibleY - playerScreenY;
        cam.viewfinder.position.y = (cam.viewfinder.position.y - adjustment).clamp(
          viewportSize.y * anchor.y,
          mapHeight - viewportSize.y * (1 - anchor.y),
        );
      }
    }

    // Clamp camera position accounting for viewfinder anchor offset
    final cameraX = cam.viewfinder.position.x
        .clamp(viewportSize.x * anchor.x, mapWidth - viewportSize.x * (1 - anchor.x))
        .toDouble();
    final cameraY = cam.viewfinder.position.y
        .clamp(viewportSize.y * anchor.y, mapHeight - viewportSize.y * (1 - anchor.y))
        .toDouble();

    cam.viewfinder.position = Vector2(cameraX, cameraY);
  }
}
