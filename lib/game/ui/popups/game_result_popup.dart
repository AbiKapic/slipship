import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../bloc/puzzle_bloc.dart';
import '../../bloc/puzzle_state.dart';

class GameResultPopup extends HookWidget {
  final bool isWin;

  const GameResultPopup({super.key, required this.isWin});

  @override
  Widget build(BuildContext context) {
    final scaleController = useAnimationController(duration: const Duration(milliseconds: 300));

    useEffect(() {
      scaleController.forward();
      return null;
    }, []);

    final scale = useAnimation(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: scaleController, curve: Curves.elasticOut)),
    );

    return BlocBuilder<PuzzleBloc, PuzzleState>(
      builder: (context, state) {
        if (!state.isGameWon && !isWin) {
          return const SizedBox.shrink();
        }

        return Material(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.white.withOpacity(0.3)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.08),
                          Colors.green.withOpacity(0.05),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.celebration, size: 80, color: Colors.yellow.withOpacity(0.9)),
                        const SizedBox(height: 24),
                        Text(
                          'You Win!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.yellow.withOpacity(0.8),
                                offset: const Offset(0, 0),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Puzzle completed successfully!',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18),
                          textAlign: TextAlign.center,
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
}
