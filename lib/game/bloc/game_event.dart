import 'package:equatable/equatable.dart';

/// Base class for all game events
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

/// Event to start a new game
class GameStarted extends GameEvent {
  const GameStarted();
}

/// Event to pause the game
class GamePaused extends GameEvent {
  const GamePaused();
}

/// Event to resume the game
class GameResumed extends GameEvent {
  const GameResumed();
}

/// Event to reset the game
class GameReset extends GameEvent {
  const GameReset();
}

/// Event when game is completed
class GameCompleted extends GameEvent {
  const GameCompleted();
}

/// Event when player moves
class PlayerMoved extends GameEvent {
  final double deltaX;
  final double deltaY;

  const PlayerMoved({
    required this.deltaX,
    required this.deltaY,
  });

  @override
  List<Object> get props => [deltaX, deltaY];
}

/// Event when player interacts
class PlayerInteracted extends GameEvent {
  const PlayerInteracted();
}



