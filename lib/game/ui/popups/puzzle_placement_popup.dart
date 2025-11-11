import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../bloc/puzzle_bloc.dart';
import '../../bloc/puzzle_state.dart';
import '../../bloc/puzzle_event.dart';
import 'package:flame/flame.dart';

class PuzzlePlacementPopup extends HookWidget {
  const PuzzlePlacementPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final puzzleSprites = useState<List<Uint8List?>>(List.filled(9, null));
    final isLoading = useState(true);

    useEffect(() {
      _loadPuzzleImages().then((images) {
        puzzleSprites.value = images;
        isLoading.value = false;
      });
      return null;
    }, []);

    return BlocBuilder<PuzzleBloc, PuzzleState>(
      builder: (context, state) {
        if (!state.isShowingPlacementPopup || state.selectedPuzzleIndex == null) {
          return const SizedBox.shrink();
        }

        final currentPieceIndex = state.selectedPuzzleIndex!;

        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {},
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.white.withOpacity(0.3)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.08),
                          Colors.blue.withOpacity(0.03),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Place Puzzle Piece',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.6),
                                offset: const Offset(0, 0),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (puzzleSprites.value[currentPieceIndex] != null)
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.memory(
                                puzzleSprites.value[currentPieceIndex]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          'Select position:',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        if (isLoading.value)
                          const CircularProgressIndicator()
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              final isOccupied = state.placedPieces.containsKey(index);
                              final isEmpty = !isOccupied;

                              return GestureDetector(
                                onTap: isEmpty
                                    ? () {
                                        final bloc = context.read<PuzzleBloc>();
                                        bloc.add(PlacePuzzle(index));
                                        bloc.add(const HidePlacementPopup());
                                      }
                                    : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isEmpty
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isEmpty
                                          ? Colors.white.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.2),
                                      width: isEmpty ? 2 : 1,
                                    ),
                                  ),
                                  child:
                                      isOccupied &&
                                          puzzleSprites.value[state.placedPieces[index]!] != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.memory(
                                            puzzleSprites.value[state.placedPieces[index]!]!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : isEmpty
                                      ? const Center(
                                          child: Icon(Icons.add, color: Colors.white70, size: 32),
                                        )
                                      : const SizedBox(),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<Uint8List?>> _loadPuzzleImages() async {
    final fullImage = await Flame.images.load('orange_cat.png');
    final images = <Uint8List?>[];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final srcX = col * 341;
        final srcY = row * 341;

        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        final srcRect = Rect.fromLTWH(srcX.toDouble(), srcY.toDouble(), 341, 341);
        final dstRect = Rect.fromLTWH(0, 0, 341, 341);

        canvas.drawImageRect(fullImage, srcRect, dstRect, Paint());

        final picture = pictureRecorder.endRecording();
        final uiImage = await picture.toImage(341, 341);
        final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
        images.add(byteData?.buffer.asUint8List());
      }
    }

    return images;
  }
}
