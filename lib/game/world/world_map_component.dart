import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:ui';



/// Component that renders the world map (ground, decorations)
class WorldMapComponent extends PositionComponent with HasGameRef {
  final int mapWidth;
  final int mapHeight;
  final double tileSize;
  final double zIndex;
  
  late final RectangleComponent _groundSprite;
  
  WorldMapComponent({
    required this.mapWidth,
    required this.mapHeight,
    required this.tileSize,
    required this.zIndex,
    super.position,
  });
  
  @override
  Future<void> onLoad() async {
    size = Vector2(mapWidth * tileSize, mapHeight * tileSize);
    priority = zIndex.toInt();
    
    // For now, create a simple colored background
    // Later this can be replaced with actual tile sprites
    _groundSprite = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF87CEEB), // Sky blue for snow
    );
    
    add(_groundSprite);
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw a simple grid pattern for now
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.0;
    
    // Vertical lines
    for (int x = 0; x <= mapWidth; x++) {
      final xPos = x * tileSize;
      canvas.drawLine(
        Offset(xPos, 0),
        Offset(xPos, mapHeight * tileSize),
        paint,
      );
    }
    
    // Horizontal lines
    for (int y = 0; y <= mapHeight; y++) {
      final yPos = y * tileSize;
      canvas.drawLine(
        Offset(0, yPos),
        Offset(mapWidth * tileSize, yPos),
        paint,
      );
    }
  }
}
