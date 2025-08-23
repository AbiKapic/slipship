import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_event.dart';
import 'game_state.dart';

/// Game BLoC for managing game state
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameStarted>(_onGameStarted);
    on<GamePaused>(_onGamePaused);
    on<GameResumed>(_onGameResumed);
    on<GameReset>(_onGameReset);
    on<GameCompleted>(_onGameCompleted);
    on<PlayerMoved>(_onPlayerMoved);
    on<PlayerInteracted>(_onPlayerInteracted);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(state.copyWith(
      status: GameStatus.playing,
      score: 0,
      level: 1,
      playerX: 0.0,
      playerY: 0.0,
      errorMessage: null,
    ));
  }

  void _onGamePaused(GamePaused event, Emitter<GameState> emit) {
    if (state.status == GameStatus.playing) {
      emit(state.copyWith(status: GameStatus.paused));
    }
  }

  void _onGameResumed(GameResumed event, Emitter<GameState> emit) {
    if (state.status == GameStatus.paused) {
      emit(state.copyWith(status: GameStatus.playing));
    }
  }

  void _onGameReset(GameReset event, Emitter<GameState> emit) {
    emit(const GameState.initial());
  }

  void _onGameCompleted(GameCompleted event, Emitter<GameState> emit) {
    emit(state.copyWith(status: GameStatus.completed));
  }

  void _onPlayerMoved(PlayerMoved event, Emitter<GameState> emit) {
    if (state.status == GameStatus.playing) {
      emit(state.copyWith(
        playerX: state.playerX + event.deltaX,
        playerY: state.playerY + event.deltaY,
      ));
    }
  }

  void _onPlayerInteracted(PlayerInteracted event, Emitter<GameState> emit) {
    if (state.status == GameStatus.playing) {
      // Handle interaction logic here
      emit(state.copyWith(
        score: state.score + 10,
      ));
    }
  }
}



