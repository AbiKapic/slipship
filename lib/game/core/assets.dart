import 'package:flame/flame.dart';
import 'dart:ui' as ui;

/// Asset keys and preloading for Snow Bridge Runner
class Assets {
  // Image keys
  static const String player = 'images/player.png';
  static const String snowTiles = 'images/snow_tiles.png';
  static const String uiButton = 'images/ui_button.png';

  // Audio keys
  static const String bgMusic = 'audio/background_music.mp3';
  static const String pickupSound = 'audio/pickup.mp3';
  static const String dropSound = 'audio/drop.mp3';
  static const String fallSound = 'audio/fall.mp3';
  static const String winSound = 'audio/win.mp3';

  // Preload all assets before entering a level
  static Future<void> preload() async {
    await Flame.images.loadAll([player, snowTiles, uiButton]);

    // Audio can be loaded on-demand for better performance
    // await Flame.audio.loadAll([
    //   bgMusic,
    //   pickupSound,
    //   dropSound,
    //   fallSound,
    //   winSound,
    // ]);
  }

  // Helper method to get image from cache
  static ui.Image fromCache(String key) => Flame.images.fromCache(key);
}
