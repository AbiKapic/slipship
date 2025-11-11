import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class PuzzleImageSplitter {
  static const int pieceSize = 341;
  static const int fullImageSize = 1024;
  static const int gridSize = 3;

  static Future<List<Sprite>> splitPuzzleImage() async {
    final image = await Flame.images.load('orange_cat.png');
    final pieces = <Sprite>[];

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final srcX = col * pieceSize;
        final srcY = row * pieceSize;

        final sprite = Sprite(
          image,
          srcPosition: Vector2(srcX.toDouble(), srcY.toDouble()),
          srcSize: Vector2(pieceSize.toDouble(), pieceSize.toDouble()),
        );

        pieces.add(sprite);
      }
    }

    return pieces;
  }

  static Vector2 getGridPosition(int gridIndex) {
    final row = gridIndex ~/ gridSize;
    final col = gridIndex % gridSize;
    return Vector2(col * pieceSize.toDouble(), row * pieceSize.toDouble());
  }

  static int getGridIndex(int row, int col) {
    return row * gridSize + col;
  }
}

