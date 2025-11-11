import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:shipslip/game/core/slip_ship_game.dart';
import 'package:shipslip/game/bloc/puzzle_bloc.dart';
import 'package:shipslip/game/bloc/puzzle_state.dart';
import 'package:shipslip/game/bloc/puzzle_event.dart';
import 'package:shipslip/game/ui/popups/puzzle_selection_popup.dart';
import 'package:shipslip/game/ui/popups/puzzle_placement_popup.dart';
import 'package:shipslip/game/ui/popups/game_result_popup.dart';
import 'package:shipslip/game/ui/popups/settings_popup.dart';
import 'package:shipslip/game/ui/widgets/game_timer.dart';

class GameScreen extends HookWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final puzzleBloc = useMemoized(() => PuzzleBloc());
    final game = useMemoized(() => SlipShipGame());

    useEffect(() {
      game.setPuzzleBloc(puzzleBloc);
      Future.delayed(const Duration(milliseconds: 500), () {
        puzzleBloc.add(const ShowSelectionPopup());
      });

      Timer? timer;
      Duration? timerStartTime;
      final subscription = puzzleBloc.stream.listen((state) {
        if (state.isTimerRunning && !state.isGameComplete) {
          if (timer == null || !timer!.isActive) {
            timerStartTime = state.elapsedTime;
            timer?.cancel();
            timer = Timer.periodic(const Duration(seconds: 1), (t) {
              if (timerStartTime != null) {
                final elapsed = timerStartTime! + Duration(seconds: t.tick);
                puzzleBloc.add(UpdateTimer(elapsed));
              }
            });
          }
        } else {
          timer?.cancel();
          timer = null;
          timerStartTime = null;
        }
      });

      return () {
        timer?.cancel();
        subscription.cancel();
        puzzleBloc.close();
      };
    }, []);

    return BlocProvider.value(
      value: puzzleBloc,
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, error) => Center(child: Text('Error loading game: $error')),
            ),
            Positioned(top: 16, left: 16, child: const GameTimer()),
            Positioned(
              top: 16,
              right: 16,
              child: BlocBuilder<PuzzleBloc, PuzzleState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(Icons.settings, color: Colors.white, size: 32),
                    onPressed: () {
                      puzzleBloc.add(const ShowSettingsPopup());
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(8),
                    ),
                  );
                },
              ),
            ),
            const PuzzleSelectionPopup(),
            const PuzzlePlacementPopup(),
            const SettingsPopup(),
            BlocBuilder<PuzzleBloc, PuzzleState>(
              builder: (context, state) {
                return GameResultPopup(isWin: state.isGameWon);
              },
            ),
          ],
        ),
      ),
    );
  }
}
