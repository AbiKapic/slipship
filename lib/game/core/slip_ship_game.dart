import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class SlipShipGame extends FlameGame {
  late TiledComponent mapComponent;

  static const double tileSize = 44.0;
  static const int mapWidth = 15;
  static const int mapHeight = 40;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _loadTmxMap();
    _setupCamera();
  }

  Future<void> _loadTmxMap() async {
    mapComponent = await TiledComponent.load(
      'slip_ship_map.tmx',
      Vector2.all(tileSize),
    );

    world.add(mapComponent);
  }

  void _setupCamera() {
    final mapSize = Vector2(mapWidth * tileSize, mapHeight * tileSize);

    camera.viewfinder.position = Vector2(mapSize.x / 2, mapSize.y / 2);
  }
}
