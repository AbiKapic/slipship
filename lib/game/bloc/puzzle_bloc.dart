import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'puzzle_event.dart';
import 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc()
      : super(
          PuzzleState(
            collectedPieces: [],
            placedPieces: {},
            isShowingSelectionPopup: false,
            isShowingPlacementPopup: false,
            puzzleScore: 0,
            isGameWon: false,
            initialOrder: _generateInitialOrder(),
            elapsedTime: Duration.zero,
            isTimerRunning: false,
            isGameComplete: false,
            isShowingSettingsPopup: false,
          ),
        ) {
    on<SelectPuzzle>(_onSelectPuzzle);
    on<TakePuzzle>(_onTakePuzzle);
    on<CrossBridge>(_onCrossBridge);
    on<PlacePuzzle>(_onPlacePuzzle);
    on<ResetPuzzle>(_onResetPuzzle);
    on<ShowSelectionPopup>(_onShowSelectionPopup);
    on<HidePlacementPopup>(_onHidePlacementPopup);
    on<StartTimer>(_onStartTimer);
    on<UpdateTimer>(_onUpdateTimer);
    on<ResetGame>(_onResetGame);
    on<QuitGame>(_onQuitGame);
    on<ShowSettingsPopup>(_onShowSettingsPopup);
    on<HideSettingsPopup>(_onHideSettingsPopup);
  }

  static List<int> _generateInitialOrder() {
    final list = List<int>.generate(9, (i) => i);
    list.shuffle(Random());
    return list;
  }

  void _onSelectPuzzle(SelectPuzzle event, Emitter<PuzzleState> emit) {
    if (state.collectedPieces.contains(event.pieceIndex)) {
      return;
    }
    emit(state.copyWith(selectedPuzzleIndex: event.pieceIndex));
  }

  void _onTakePuzzle(TakePuzzle event, Emitter<PuzzleState> emit) {
    if (state.selectedPuzzleIndex == null) {
      return;
    }

    final newCollectedPieces = [...state.collectedPieces, state.selectedPuzzleIndex!];
    final shouldStartTimer = !state.isTimerRunning && state.collectedPieces.isEmpty;
    
    emit(
      state.copyWith(
        collectedPieces: newCollectedPieces,
        isShowingSelectionPopup: false,
        isTimerRunning: shouldStartTimer ? true : state.isTimerRunning,
      ),
    );
  }

  void _onCrossBridge(CrossBridge event, Emitter<PuzzleState> emit) {
    if (state.isCarryingPiece) {
      emit(state.copyWith(isShowingPlacementPopup: true));
    }
  }

  void _onPlacePuzzle(PlacePuzzle event, Emitter<PuzzleState> emit) {
    if (state.selectedPuzzleIndex == null) {
      return;
    }

    final pieceIndex = state.selectedPuzzleIndex!;
    final newPlacedPieces = Map<int, int>.from(state.placedPieces);
    newPlacedPieces[event.gridPosition] = pieceIndex;

    final newCollectedPieces = state.collectedPieces.where((p) => p != pieceIndex).toList();

    final isCorrect = pieceIndex == event.gridPosition;
    final newScore = state.puzzleScore + (isCorrect ? 1 : 0);

    final allPlaced = newPlacedPieces.length == 9;
    final allCorrect = allPlaced && _checkAllPiecesCorrect(newPlacedPieces);

    emit(
      state.copyWith(
        selectedPuzzleIndex: null,
        collectedPieces: newCollectedPieces,
        placedPieces: newPlacedPieces,
        isShowingPlacementPopup: false,
        puzzleScore: newScore,
        isGameWon: allCorrect,
        isGameComplete: allPlaced,
      ),
    );
  }

  void _onResetPuzzle(ResetPuzzle event, Emitter<PuzzleState> emit) {
    emit(
      PuzzleState(
        selectedPuzzleIndex: null,
        collectedPieces: [],
        placedPieces: {},
        isShowingSelectionPopup: false,
        isShowingPlacementPopup: false,
        puzzleScore: 0,
        isGameWon: false,
        initialOrder: state.initialOrder,
        elapsedTime: Duration.zero,
        isTimerRunning: false,
        isGameComplete: false,
        isShowingSettingsPopup: false,
      ),
    );
  }

  void _onStartTimer(StartTimer event, Emitter<PuzzleState> emit) {
    if (!state.isTimerRunning) {
      emit(state.copyWith(isTimerRunning: true));
    }
  }

  void _onUpdateTimer(UpdateTimer event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(elapsedTime: event.elapsedTime));
  }

  void _onResetGame(ResetGame event, Emitter<PuzzleState> emit) {
    emit(
      PuzzleState(
        selectedPuzzleIndex: null,
        collectedPieces: [],
        placedPieces: {},
        isShowingSelectionPopup: false,
        isShowingPlacementPopup: false,
        puzzleScore: 0,
        isGameWon: false,
        initialOrder: _generateInitialOrder(),
        elapsedTime: Duration.zero,
        isTimerRunning: false,
        isGameComplete: false,
        isShowingSettingsPopup: false,
      ),
    );
  }

  void _onQuitGame(QuitGame event, Emitter<PuzzleState> emit) {
  }

  void _onShowSettingsPopup(ShowSettingsPopup event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(isShowingSettingsPopup: true));
  }

  void _onHideSettingsPopup(HideSettingsPopup event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(isShowingSettingsPopup: false));
  }

  void _onShowSelectionPopup(ShowSelectionPopup event, Emitter<PuzzleState> emit) {
    if (!state.isCarryingPiece && state.uncollectedPieces.isNotEmpty) {
      emit(state.copyWith(isShowingSelectionPopup: true));
    }
  }

  void _onHidePlacementPopup(HidePlacementPopup event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(isShowingPlacementPopup: false));
  }

  bool _checkAllPiecesCorrect(Map<int, int> placedPieces) {
    if (placedPieces.length != 9) return false;
    for (int i = 0; i < 9; i++) {
      if (placedPieces[i] != i) return false;
    }
    return true;
  }
}

