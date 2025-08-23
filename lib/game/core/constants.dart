import 'package:flame/components.dart';

/// Game constants for Snow Bridge Runner
class GameConstants {
  // Tile and world settings
  static const double tileSize = 64.0;
  static const double baseDesignWidth = 1280.0;
  static const double baseDesignHeight = 720.0;
  
  // Player settings
  static const double playerBaseSpeed = 120.0; // units/sec
  static const double playerCarryPenalty = 0.7; // speed multiplier when carrying
  static const double playerPickupRadius = 0.8; // tiles
  static const double playerSnapRadius = 0.6; // tiles for board placement
  
  // River system settings
  static const int riverCycleMs = 1200; // milliseconds between stepping tile toggles
  static const int waterAnimationStepTime = 120; // milliseconds per water frame
  
  // Z-index layers (higher numbers render on top)
  static const double zGround = 0.0;
  static const double zWater = 1.0;
  static const double zSteppingTiles = 2.0;
  static const double zDecor = 3.0;
  static const double zPlayer = 4.0;
  static const double zPuzzlePieces = 5.0;
  static const double zGoalBoard = 6.0;
  static const double zUI = 10.0;
  static const double zOverlay = 20.0;
  
  // Animation settings
  static const double playerWalkStepTime = 0.12; // seconds per frame
  static const double playerIdleStepTime = 1.0; // seconds per frame
  
  // Game settings
  static const int puzzlePiecesRequired = 9; // 3x3 board
  static const double respawnInvincibilityTime = 1.0; // seconds
  
  // UI settings
  static const double hudPadding = 16.0;
  static const double buttonSize = 64.0;
  static const double joystickSize = 120.0;
  
  // Helper methods
  static double tilesToPixels(double tiles) => tiles * tileSize;
  static double pixelsToTiles(double pixels) => pixels / tileSize;
  
  static Vector2 tilePosition(int x, int y) => Vector2(
    x * tileSize,
    y * tileSize,
  );
}
