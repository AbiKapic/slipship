import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'dart:ui' as ui;

import '../world/collision_manager.dart';
import '../entities/collision_tile.dart';
import '../entities/kid.dart';
import '../entities/puzzle_piece.dart';
import '../entities/puzzle_grid.dart';
import '../entities/start_position_marker.dart';
import '../ui/directional_pad.dart';
import '../bloc/puzzle_bloc.dart';
import '../bloc/puzzle_event.dart';
import '../utils/puzzle_image_splitter.dart';

class SlipShipGame extends FlameGame with HasCollisionDetection {
  @override
  late final World world;
  late final CameraComponent cam;

  late final TiledComponent level;
  late final Kid player;
  late final List<CollisionTile> collisionTiles;
  late final List<CollisionTile> riverTiles;
  late final List<CollisionTile> bridgeTiles;
  late final DirectionalPad dPad;
  late final Vector2 startPosition;

  PuzzleBloc? puzzleBloc;
  PuzzlePiece? currentPuzzlePiece;
  PuzzleGrid? puzzleGrid;
  List<Sprite> puzzleSprites = [];

  bool _wasAtStartPosition = false;
  static const double _startPositionThreshold = 30.0;
  bool _placementPopupLock = false;

  final Vector2 _velocity = Vector2.zero();
  final double _accel = 900;
  final double _decel = 1400;
  double _waterSlideTimer = 0.0;
  static const double _waterSlideDuration = 0.3;

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

    final mapWidth = 15 * 44.0;
    final mapHeight = 40 * 44.0;
    startPosition = Vector2(mapWidth / 2, mapHeight - 24);

    collisionTiles = <CollisionTile>[];
    riverTiles = <CollisionTile>[];
    bridgeTiles = <CollisionTile>[];
    final tileLayers = level.tileMap.map.layers.whereType<TileLayer>();

    for (final layer in tileLayers) {
      if (layer.name == 'river') {
        final layerCollisions = CollisionManager.createCollisionTilesFromLayer(layer, 44, 44);
        riverTiles.addAll(layerCollisions);
        world.addAll(layerCollisions);
      } else if (layer.name == 'bridge') {
        final layerCollisions = CollisionManager.createCollisionTilesFromLayer(layer, 44, 44);
        bridgeTiles.addAll(layerCollisions);
        world.addAll(layerCollisions);
      } else if (layer.name != 'ground') {
        final layerCollisions = CollisionManager.createCollisionTilesFromLayer(layer, 44, 44);
        collisionTiles.addAll(layerCollisions);
        world.addAll(layerCollisions);
      }
    }

    player = Kid()..position = startPosition.clone();
    world.add(player);

    // 5) Set camera to look at player position
    cam.moveTo(player.position.clone());

    // 6) Camera follows player
    cam.follow(player, maxSpeed: 300);

    // 7) Add Directional Pad as HUD (fixed to viewport) - positioned at bottom-left
    dPad = DirectionalPad()..priority = 1000;

    // Attach to camera viewport so it stays pinned to screen
    cam.viewport.add(dPad);

    puzzleSprites = await PuzzleImageSplitter.splitPuzzleImage();

    final gridMapWidth = 15 * 44.0;
    puzzleGrid = PuzzleGrid(
      placedPieces: {},
      puzzleSprites: puzzleSprites,
      position: Vector2(gridMapWidth / 2 - PuzzleGrid.totalGridSize / 2 + 100, 120),
      isGameComplete: false,
    );
    world.add(puzzleGrid!);

    final startMarker = StartPositionMarker(position: startPosition.clone());
    world.add(startMarker);
  }

  void setPuzzleBloc(PuzzleBloc bloc) {
    puzzleBloc = bloc;
    _setupPuzzleBlocListener();
  }

  void _setupPuzzleBlocListener() {
    puzzleBloc?.stream.listen((state) {
      if (currentPuzzlePiece != null &&
          (state.selectedPuzzleIndex == null || !state.isCarryingPiece)) {
        currentPuzzlePiece?.removeFromParent();
        currentPuzzlePiece = null;
      }

      if (state.selectedPuzzleIndex != null && currentPuzzlePiece == null) {
        final pieceIndex = state.selectedPuzzleIndex!;
        if (pieceIndex < puzzleSprites.length) {
          currentPuzzlePiece = PuzzlePiece(
            pieceIndex: pieceIndex,
            player: player,
            sprite: puzzleSprites[pieceIndex],
          );
          world.add(currentPuzzlePiece!);
        }
      }

      if (puzzleGrid != null) {
        final newPlacedPieces = Map<int, int>.from(state.placedPieces);
        puzzleGrid!.placedPieces.clear();
        puzzleGrid!.placedPieces.addAll(newPlacedPieces);
        puzzleGrid!.isGameComplete = state.isGameComplete;
      }
    });
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

    final isCarryingPiece = puzzleBloc?.state.isCarryingPiece ?? false;
    if (isCarryingPiece) {
      targetSpeed *= 0.85;
    }

    if (inputDir.length2 > 0) {
      final desiredVel = inputDir * targetSpeed;
      final deltaVel = desiredVel - _velocity;
      final maxChange = _accel * dt;
      if (deltaVel.length <= maxChange) {
        _velocity.setFrom(desiredVel);
      } else {
        _velocity.add(deltaVel.normalized() * maxChange);
      }

      if (isCarryingPiece) {
        _velocity.scale(0.92);
      }
    } else if (_velocity.length2 > 0) {
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

      candidate = Vector2(player.position.x, player.position.y + dy);
      if (!CollisionManager.checkCollision(candidate, player.size, collisionTiles)) {
        player.position.y = candidate.y;
      } else {
        _velocity.y = 0;
      }

      final mapWidth = 15 * 44.0;
      final mapHeight = 40 * 44.0;
      final playerHalfWidth = player.size.x / 2;

      player.position.x = player.position.x
          .clamp(playerHalfWidth, mapWidth - playerHalfWidth)
          .toDouble();
      player.position.y = player.position.y.clamp(player.size.y, mapHeight).toDouble();
    }

    final isOnBridge = CollisionManager.checkCollision(player.position, player.size, bridgeTiles);
    final isOnWater =
        CollisionManager.checkCollision(player.position, player.size, riverTiles) ||
        CollisionManager.checkCollision(
          Vector2(player.position.x - 8, player.position.y),
          player.size,
          riverTiles,
        ) ||
        CollisionManager.checkCollision(
          Vector2(player.position.x + 8, player.position.y),
          player.size,
          riverTiles,
        );

    if (isOnWater && !isOnBridge) {
      if (inputDir.length2 > 0) {
        final waterFriction = 0.6;
        _velocity.scale(1.0 - waterFriction * dt * 3);
      } else {
        final waterPush = Vector2(0, 80);
        _velocity.add(waterPush * dt);
        final speed = _velocity.length;
        final drop = _decel * 0.15 * dt;
        final newSpeed = (speed - drop).clamp(0, double.infinity);
        if (newSpeed == 0) {
          _velocity.setZero();
        } else {
          _velocity.scale(newSpeed / speed);
        }
      }

      _waterSlideTimer += dt;
      if (_waterSlideTimer >= _waterSlideDuration) {
        puzzleBloc?.add(const ResetPuzzle());
        player.position.setFrom(startPosition);
        _velocity.setZero();
        cam.viewfinder.position.setFrom(startPosition);
        _waterSlideTimer = 0.0;
      }
    } else {
      _waterSlideTimer = 0.0;
    }

    if (puzzleGrid != null) {
      final gridRect = ui.Rect.fromLTWH(
        puzzleGrid!.position.x,
        puzzleGrid!.position.y,
        PuzzleGrid.totalGridSize,
        PuzzleGrid.totalGridSize,
      ).inflate(16);
      final p = ui.Offset(player.position.x, player.position.y);
      final isInGrid = gridRect.contains(p);

      if (!isInGrid) {
        _placementPopupLock = false;
      } else if (puzzleBloc?.state.isCarryingPiece == true &&
          (puzzleBloc?.state.isShowingPlacementPopup == false) &&
          !_placementPopupLock) {
        _placementPopupLock = true;
        puzzleBloc?.add(const CrossBridge());
      }
    }

    final distanceToStart = (player.position - startPosition).length;
    final isAtStartPosition = distanceToStart < _startPositionThreshold;

    if (isAtStartPosition && !_wasAtStartPosition) {
      if (puzzleBloc?.state.isCarryingPiece == false &&
          puzzleBloc?.state.uncollectedPieces.isNotEmpty == true) {
        puzzleBloc?.add(const ShowSelectionPopup());
      }
    }
    _wasAtStartPosition = isAtStartPosition;

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
