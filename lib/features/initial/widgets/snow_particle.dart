import 'dart:math';
import 'package:flutter/material.dart';

class SnowParticle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double rotation;
  double rotationSpeed;
  Color color;

  SnowParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
  });

  void update(double screenHeight, double screenWidth) {
    y += speed;
    x += sin(y * 0.01) * 0.5;
    rotation += rotationSpeed;

    if (y > screenHeight + size) {
      y = -size;
      x = Random().nextDouble() * screenWidth;
    }

    if (x > screenWidth + size) {
      x = -size;
    } else if (x < -size) {
      x = screenWidth + size;
    }
  }

  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 2, spreadRadius: 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

