import 'package:equatable/equatable.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object?> get props => [];
}

class SelectPuzzle extends PuzzleEvent {
  final int pieceIndex;

  const SelectPuzzle(this.pieceIndex);

  @override
  List<Object?> get props => [pieceIndex];
}

class TakePuzzle extends PuzzleEvent {
  const TakePuzzle();
}

class CrossBridge extends PuzzleEvent {
  const CrossBridge();
}

class PlacePuzzle extends PuzzleEvent {
  final int gridPosition;

  const PlacePuzzle(this.gridPosition);

  @override
  List<Object?> get props => [gridPosition];
}

class ResetPuzzle extends PuzzleEvent {
  const ResetPuzzle();
}

class ShowSelectionPopup extends PuzzleEvent {
  const ShowSelectionPopup();
}

class HidePlacementPopup extends PuzzleEvent {
  const HidePlacementPopup();
}

class StartTimer extends PuzzleEvent {
  const StartTimer();
}

class UpdateTimer extends PuzzleEvent {
  final Duration elapsedTime;

  const UpdateTimer(this.elapsedTime);

  @override
  List<Object?> get props => [elapsedTime];
}

class ResetGame extends PuzzleEvent {
  const ResetGame();
}

class QuitGame extends PuzzleEvent {
  const QuitGame();
}

class ShowSettingsPopup extends PuzzleEvent {
  const ShowSettingsPopup();
}

class HideSettingsPopup extends PuzzleEvent {
  const HideSettingsPopup();
}

