import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/experimental.dart' show Rectangle;
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:flutter/widgets.dart' show EdgeInsets;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shipslip/game/components/finish_zone.dart';
import 'package:shipslip/game/components/ice_area.dart';
import 'package:shipslip/game/components/player.dart';
import 'package:shipslip/game/components/snow_area.dart';
import 'package:shipslip/world/map_loader.dart';
import 'package:shipslip/input/input_handler.dart';
import 'package:shipslip/utils/asset_keys.dart';

class ShipSlipGame extends Forge2DGame with HasKeyboardHandlerComponents {
  ShipSlipGame({required this.onLevelComplete})
    : super(gravity: Vector2.zero());

  final VoidCallback onLevelComplete;
  late final InputHandler _inputHandler;
  late final Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Viewport: use default so scaling adapts to device; background is fitted below

    images.prefix = 'assets/images/';
    Vector2 worldSize;
    try {
      // Load the Tiled map using the MapLoader
      final tiledMap = await MapLoader.loadBackground();
      final bg = tiledMap
        ..anchor = Anchor.topLeft
        ..position = Vector2.zero();

      // Set world size based on map dimensions (40x24 tiles, 128x128 each)
      worldSize = Vector2(5120, 3072); // 40 * 128, 24 * 128

      camera.backdrop.add(bg);

      // Clamp camera to the background bounds
      camera.setBounds(
        Rectangle.fromLTWH(0, 0, worldSize.x, worldSize.y),
        considerViewport: true,
      );
    } catch (e) {
      print('Error loading Tiled map: $e');
      camera.backdrop.add(
        RectangleComponent(
          size: size.clone(),
          paint: Paint()..color = const Color(0xFF0A0E14),
        ),
      );
      worldSize = size.clone();
    }

    add(
      IceArea(
        areaCenter: Vector2(worldSize.x * 0.25, worldSize.y * 0.5),
        width: worldSize.x * 0.5,
        height: worldSize.y * 0.9,
      ),
    );
    add(
      SnowArea(
        areaCenter: Vector2(worldSize.x * 0.75, worldSize.y * 0.5),
        width: worldSize.x * 0.5,
        height: worldSize.y * 0.9,
      ),
    );

    add(
      FinishZone(
        areaCenter: Vector2(worldSize.x * 0.85, worldSize.y * 0.2),
        radius: 20,
        onReached: onLevelComplete,
      ),
    );

    _inputHandler = InputHandler();
    final joystick = _inputHandler.createJoystick(size);
    camera.viewport.add(joystick);
    // Let viewport consume pointer events for joystick
    camera.viewport.priority = 999;

    player = Player(joystickProvider: () => joystick)
      ..initialPosition = Vector2(worldSize.x * 0.15, worldSize.y * 0.2);
    await add(player);
    camera.follow(player, snap: true);
  }
}
