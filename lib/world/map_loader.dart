import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/components.dart';

class MapLoader {
  static const String _levelsPath = 'assets/levels/';
  static const String _tilesetsPath = 'assets/maps/';

  /// Loads a Tiled map from the levels directory
  static Future<TiledComponent> loadLevel(String levelName) async {
    final mapPath = '$_levelsPath$levelName.tmx';
    return await TiledComponent.load(mapPath, Vector2.all(1.0));
  }

  /// Loads the background map
  static Future<TiledComponent> loadBackground() async {
    return await loadLevel('background');
  }

  /// Gets available level names
  static List<String> getAvailableLevels() {
    return [
      'background',
      'snowy_world',
      'snowy_world_complete',
      'snowy_world_final',
      'snowy_world_rich',
    ];
  }
}

