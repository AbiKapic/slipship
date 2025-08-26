import 'package:flutter/material.dart';

class BackgroundDecoration {
  const BackgroundDecoration();

  BoxDecoration buildDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}

