import 'package:equatable/equatable.dart';

/// Game status enum
enum GameStatus {
  initial,
  loading,
  playing,
  paused,
  completed,
  failed,
}

/// Game state class
class GameState extends Equatable {
  final GameStatus status;
  final int score;
  final int level;
  final double playerX;
  final double playerY;
  final String? errorMessage;

  const GameState({
    this.status = GameStatus.initial,
    this.score = 0,
    this.level = 1,
    this.playerX = 0.0,
    this.playerY = 0.0,
    this.errorMessage,
  });

  /// Create initial state
  const GameState.initial() : this();

  /// Create loading state
  const GameState.loading() : this(status: GameStatus.loading);

  /// Copy with method for immutable state updates
  GameState copyWith({
    GameStatus? status,
    int? score,
    int? level,
    double? playerX,
    double? playerY,
    String? errorMessage,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      level: level ?? this.level,
      playerX: playerX ?? this.playerX,
      playerY: playerY ?? this.playerY,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        score,
        level,
        playerX,
        playerY,
        errorMessage,
      ];
}



