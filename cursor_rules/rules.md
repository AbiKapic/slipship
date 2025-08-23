You are an expert in Flutter, Dart, Riverpod, Freezed, Flutter Hooks, and Supabase and 2D FLAME.


# Snow Bridge Runner - Development Rules

## Architecture

Game logic is Flame-native (components + update loop). Use Bloc only for out-of-game UI.

Every in-world object is a PositionComponent subclass with explicit zIndex (see constants.dart).

No global singletons other than Images, AudioPlayer, and GameRef. Pass references explicitly.

## Assets

All assets preloaded via Assets.preload() before entering a level.

Sprite sheets must be sliced using SpriteSheet.fromColumnsAndRows.

Never hardcode pixel sizes; use tileSize from constants.dart.

## Collision

Use HasCollisionDetection; hitboxes are rectangles matching feet (for player) and tile bounds for hazards/stepping.

Water is non-colliding but tagged as HAZARD; stepping tiles are collidable while active.

## Animation

Player uses SpriteAnimationGroupComponent<PlayerState, Direction>.

Directions: up/down/right; left is right with flipHorizontallyAroundCenter().

Water animates via 4-frame SpriteAnimation.

## Scheduler

River stepping tiles change states with a deterministic pattern list (e.g., [A on, B off] → [A off, B on]).

All time values come from constants.dart (e.g., riverCycleMs).

## Interacts

Pickup requires proximity + onTap/virtual "action" button; while carrying, reduce speed by carryPenalty.

Dropping on board snaps to nearest empty cell center (if within snap radius).

## Camera

Use CameraComponent.withFixedResolution(1280, 720) and follow the player with dead-zone.

## Testing/QA

Provide a GoldenLevel map with deterministic river cycle for tests.

Add asserts for tile IDs in level_loader.dart.

## Folder Layout

```
lib/
  app/                     # Flutter wrappers (MaterialApp, routes, DI)
    app.dart
    routes.dart
  game/
    core/
      snow_runner_game.dart      # FlameGame root, camera, world loading, asset cache
      assets.dart                # image/audio keys + preload list
      constants.dart             # tileSize, zIndexes, speeds
      input.dart                 # virtual joystick / tap controls mapping
      collisions.dart            # hitbox helpers
      scheduler.dart             # river toggle scheduler
    world/
      level_loader.dart          # load from Tiled TMX or JSON
      world_map_component.dart   # static layers: ground, decor
      river_system.dart          # animated water + stepping logic
      goal_board_component.dart  # 3x3 board snap + win check
    entities/
      player.dart                # SpriteAnimationGroupComponent (Idle/Walk + Carry)
      puzzle_piece.dart          # Draggable/Grabbable + snap logic
      stepping_tile.dart         # togglable safe tile over water
      tree.dart, rock.dart       # decorations (non-collidable)
    ui/
      hud.dart                   # timer, deaths, pieces delivered
      menus/
        main_menu_page.dart
        pause_overlay.dart
        win_overlay.dart
    services/
      save_service.dart          # SharedPreferences for simple stats
  features/settings/             # optional bloc for audio/sensitivity etc.
```

## Implementation Notes

### Player animation
```dart
enum MoveDir { up, down, right, left }
enum PlayerState { idle, walking, carryingIdle, carryingWalk }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, HasGameRef<SnowRunnerGame> {

  static const double baseSpeed = 120; // units/sec
  late final Map<PlayerState, SpriteAnimation> _anims;
  MoveDir dir = MoveDir.down;
  bool carrying = false;

  Player();

  @override
  Future<void> onLoad() async {
    final img = game.images.fromCache(Assets.player);
    // 3x3 grid
    final sheet = SpriteSheet(image: img, srcSize: Vector2(img.width / 3, img.height / 3));

    final rightWalk = sheet.createAnimation(row: 0, stepTime: 0.12, to: 3);
    final downWalk  = sheet.createAnimation(row: 1, stepTime: 0.12, to: 3);
    final upWalk    = sheet.createAnimation(row: 2, stepTime: 0.12, to: 3);

    _anims = {
      PlayerState.walking: downWalk, // default; we'll swap based on dir in update
      PlayerState.idle: SpriteAnimation.spriteList([sheet.getSprite(1, 1)], stepTime: 1.0),
      PlayerState.carryingWalk: downWalk, // same frames; overlay a carried sprite
      PlayerState.carryingIdle: SpriteAnimation.spriteList([sheet.getSprite(1, 1)], stepTime: 1.0),
    };

    animations = _anims;
    current = PlayerState.idle;

    // feet hitbox smaller than sprite
    add(RectangleHitbox.relative(
      Vector2(0.4, 0.2),
      position: Vector2(size.x * 0.3, size.y * 0.75),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // velocity comes from input system; set animation & flipping here
    // when dir == left, call flipHorizontallyAroundCenter() if not already flipped
  }
}
```

### River + stepping tiles
Represent river as a layer of animated water tiles (pure visuals) plus a grid of logical cells with a hazard: true.

Add SteppingTile components placed over selected river cells. Each has active: bool and a RectangleHitbox only when active.

A RiverSystem holds a List<List<SteppingTile>> and a cycle table (e.g., columns A/C on while B/D off → toggle every riverCycleMs).

When a player's feet overlap a river cell without an active stepping tile, trigger onFall() → fade out → respawn.

### Puzzle & board
Each piece is a SpriteComponent with Grabbable behavior:

When close + "action", piece.attachTo(player); while attached it follows an offset above the player.

On second "action" near the board, the board checks the nearest cell; if empty, snap and lock.

Board keeps a 3×3 boolean map; when all true → game.onWin().

## Rules

Follow the folder layout above; never place game components in features/.

Use CameraComponent.withFixedResolution(1280, 720) and World/Camera API (no game.camera.followVector2 hacks).

All components declare priority/zIndex via constants.dart.

Tile math is always in tile units; convert to pixels with * tileSize.

Input is abstracted in core/input.dart; entities read it via gameRef.input.

All timings (animation step times, scheduler, invincibility windows) live in constants.dart.

Player left animation is right with horizontal flip (keep spritesheet minimal).

Water is a hazard; stepping tiles toggle colliders; river logic never disables water animation.

Snap logic for the board must be idempotent and deterministic (same input → same placement).

Before merging, run: flutter analyze and a manual play test on a low-end Android emulator.
