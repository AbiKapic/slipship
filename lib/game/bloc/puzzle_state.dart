import 'package:equatable/equatable.dart';

class PuzzleState extends Equatable {
  final int? selectedPuzzleIndex;
  final List<int> collectedPieces;
  final Map<int, int> placedPieces;
  final bool isShowingSelectionPopup;
  final bool isShowingPlacementPopup;
  final int puzzleScore;
  final bool isGameWon;
  final List<int> initialOrder;
  final Duration elapsedTime;
  final bool isTimerRunning;
  final bool isGameComplete;
  final bool isShowingSettingsPopup;

  const PuzzleState({
    this.selectedPuzzleIndex,
    required this.collectedPieces,
    required this.placedPieces,
    required this.isShowingSelectionPopup,
    required this.isShowingPlacementPopup,
    required this.puzzleScore,
    this.isGameWon = false,
    required this.initialOrder,
    this.elapsedTime = Duration.zero,
    this.isTimerRunning = false,
    this.isGameComplete = false,
    this.isShowingSettingsPopup = false,
  });

  PuzzleState copyWith({
    Object? selectedPuzzleIndex = _undefined,
    List<int>? collectedPieces,
    Map<int, int>? placedPieces,
    bool? isShowingSelectionPopup,
    bool? isShowingPlacementPopup,
    int? puzzleScore,
    bool? isGameWon,
    List<int>? initialOrder,
    Duration? elapsedTime,
    bool? isTimerRunning,
    bool? isGameComplete,
    bool? isShowingSettingsPopup,
  }) {
    return PuzzleState(
      selectedPuzzleIndex: selectedPuzzleIndex == _undefined
          ? this.selectedPuzzleIndex
          : selectedPuzzleIndex as int?,
      collectedPieces: collectedPieces ?? this.collectedPieces,
      placedPieces: placedPieces ?? this.placedPieces,
      isShowingSelectionPopup: isShowingSelectionPopup ?? this.isShowingSelectionPopup,
      isShowingPlacementPopup: isShowingPlacementPopup ?? this.isShowingPlacementPopup,
      puzzleScore: puzzleScore ?? this.puzzleScore,
      isGameWon: isGameWon ?? this.isGameWon,
      initialOrder: initialOrder ?? this.initialOrder,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      isGameComplete: isGameComplete ?? this.isGameComplete,
      isShowingSettingsPopup: isShowingSettingsPopup ?? this.isShowingSettingsPopup,
    );
  }

  static const Object _undefined = Object();

  bool get isCarryingPiece => selectedPuzzleIndex != null;

  List<int> get uncollectedPieces {
    final allPieces = List.generate(9, (index) => index);
    return allPieces.where((piece) => !collectedPieces.contains(piece)).toList();
  }

  @override
  List<Object?> get props => [
    selectedPuzzleIndex,
    collectedPieces,
    placedPieces,
    isShowingSelectionPopup,
    isShowingPlacementPopup,
    puzzleScore,
    isGameWon,
    initialOrder,
    elapsedTime,
    isTimerRunning,
    isGameComplete,
    isShowingSettingsPopup,
  ];
}
