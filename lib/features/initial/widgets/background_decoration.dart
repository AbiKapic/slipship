import 'package:flutter/material.dart';

class BackgroundDecoration {
  const BackgroundDecoration();

  BoxDecoration buildDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF87CEEB),
          Color(0xFF6BB6FF),
          Color(0xFF4A90E2),
          Color(0xFF2E5B8A),
          Color(0xFF1E3A5F),
        ],
        stops: [0.0, 0.3, 0.6, 0.8, 1.0],
      ),
    );
  }
}
