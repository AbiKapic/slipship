import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../core/constants.dart';

/// 3x3 goal board where puzzle pieces are placed
class GoalBoardComponent extends PositionComponent with HasGameRef {
  final double zIndex;
  
  static const int boardSize = 3; // 3x3 grid
  late final List<List<bool>> _grid;
  late final List<List<RectangleComponent>> _gridCells;
  
  GoalBoardComponent({
    required this.zIndex,
    super.position,
  });
  
  @override
  Future<void> onLoad() async {
    size = Vector2.all(boardSize * GameConstants.tileSize);
    priority = zIndex.toInt();
    
    _grid = List.generate(
      boardSize,
      (i) => List.generate(boardSize, (j) => false),
    );
    
    _gridCells = [];
    _createGridCells();
  }
  
  void _createGridCells() {
    for (int row = 0; row < boardSize; row++) {
      _gridCells.add([]);
      for (int col = 0; col < boardSize; col++) {
        final cell = RectangleComponent(
          position: Vector2(
            col * GameConstants.tileSize,
            row * GameConstants.tileSize,
          ),
          size: Vector2.all(GameConstants.tileSize),
          paint: Paint()
            ..color = Colors.white.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );
        
        _gridCells[row].add(cell);
        add(cell);
      }
    }
  }
  
  /// Try to place a puzzle piece at the nearest empty cell
  /// Returns true if placement was successful
  bool tryPlacePiece(Vector2 piecePosition) {
    final nearestCell = _findNearestEmptyCell(piecePosition);
    if (nearestCell == null) return false;
    
    final row = nearestCell.row;
    final col = nearestCell.col;
    
    // Check if within snap radius
    final cellCenter = Vector2(
      position.x + (col + 0.5) * GameConstants.tileSize,
      position.y + (row + 0.5) * GameConstants.tileSize,
    );
    
    final distance = piecePosition.distanceTo(cellCenter);
    if (distance > GameConstants.playerSnapRadius * GameConstants.tileSize) {
      return false;
    }
    
    // Place the piece
    _grid[row][col] = true;
    _gridCells[row][col].paint.color = Colors.green.withOpacity(0.5);
    
    return true;
  }
  
  /// Find the nearest empty cell to the given position
  _CellPosition? _findNearestEmptyCell(Vector2 position) {
    double minDistance = double.infinity;
    _CellPosition? nearestCell;
    
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (_grid[row][col]) continue; // Cell is occupied
        
        final cellCenter = Vector2(
          this.position.x + (col + 0.5) * GameConstants.tileSize,
          this.position.y + (row + 0.5) * GameConstants.tileSize,
        );
        
        final distance = position.distanceTo(cellCenter);
        if (distance < minDistance) {
          minDistance = distance;
          nearestCell = _CellPosition(row, col);
        }
      }
    }
    
    return nearestCell;
  }
  
  /// Check if the board is complete (all 9 pieces placed)
  bool get isComplete {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (!_grid[row][col]) return false;
      }
    }
    return true;
  }
  
  /// Get the number of pieces placed
  int get piecesPlaced {
    int count = 0;
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (_grid[row][col]) count++;
      }
    }
    return count;
  }
}

/// Helper class for cell positions
class _CellPosition {
  final int row;
  final int col;
  
  _CellPosition(this.row, this.col);
}
