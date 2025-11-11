import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../core/slip_ship_game.dart';
import '../utils/puzzle_image_splitter.dart';

class PuzzleGrid extends PositionComponent with HasGameReference<SlipShipGame> {
  Map<int, int> placedPieces;
  final List<Sprite> puzzleSprites;
  bool isGameComplete;
  static const double gridPieceSize = 60.0;
  static const double gridSpacing = 2.0;
  static const double totalGridSize = (gridPieceSize * 3) + (gridSpacing * 2);

  PuzzleGrid({
    required this.placedPieces,
    required this.puzzleSprites,
    required super.position,
    this.isGameComplete = false,
  }) : super(
          anchor: Anchor.topLeft,
          size: Vector2(totalGridSize, totalGridSize),
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()
        ..color = const Color(0x88000000)
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final gridIndex = PuzzleImageSplitter.getGridIndex(row, col);
        final pieceIndex = placedPieces[gridIndex];

        final x = col * (gridPieceSize + gridSpacing);
        final y = row * (gridPieceSize + gridSpacing);

        if (pieceIndex != null && pieceIndex < puzzleSprites.length) {
          if (isGameComplete) {
            puzzleSprites[pieceIndex].render(
              canvas,
              position: Vector2(x, y),
              size: Vector2(gridPieceSize, gridPieceSize),
            );
          } else {
            final paint = Paint()
              ..color = Colors.grey.withOpacity(0.7)
              ..style = PaintingStyle.fill;
            canvas.drawRect(
              Rect.fromLTWH(x, y, gridPieceSize, gridPieceSize),
              paint,
            );
            
            final patternPaint = Paint()
              ..color = Colors.white.withOpacity(0.3)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0;
            canvas.drawLine(
              Offset(x + 5, y + 5),
              Offset(x + gridPieceSize - 5, y + gridPieceSize - 5),
              patternPaint,
            );
            canvas.drawLine(
              Offset(x + gridPieceSize - 5, y + 5),
              Offset(x + 5, y + gridPieceSize - 5),
              patternPaint,
            );
          }
        } else {
          canvas.drawRect(
            Rect.fromLTWH(x, y, gridPieceSize, gridPieceSize),
            Paint()
              ..color = Colors.grey.withOpacity(0.3)
              ..style = PaintingStyle.fill,
          );
        }

        canvas.drawRect(
          Rect.fromLTWH(x, y, gridPieceSize, gridPieceSize),
          Paint()
            ..color = Colors.white.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0,
        );
      }
    }
  }
}

