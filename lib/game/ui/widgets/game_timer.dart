import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/puzzle_bloc.dart';
import '../../bloc/puzzle_state.dart';

class GameTimer extends HookWidget {
  const GameTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: BlocBuilder<PuzzleBloc, PuzzleState>(
        builder: (context, state) {
          final minutes = state.elapsedTime.inMinutes;
          final seconds = state.elapsedTime.inSeconds % 60;
          final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          
          return Text(
            timeString,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.6),
                  offset: const Offset(0, 0),
                  blurRadius: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

