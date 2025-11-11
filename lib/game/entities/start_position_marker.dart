import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../core/slip_ship_game.dart';

class StartPositionMarker extends PositionComponent with HasGameReference<SlipShipGame> {
  StartPositionMarker({required super.position}) : super(
    anchor: Anchor.center,
    priority: 3,
  );

  @override
  Future<void> onLoad() async {
    size = Vector2(200, 80);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-size.x / 2, -size.y / 2),
        Offset(size.x / 2, size.y / 2),
        [
          Colors.cyan.withOpacity(0.4),
          Colors.blue.withOpacity(0.35),
        ],
      )
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(rrect, gradientPaint);

    final borderPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    
    canvas.drawRRect(rrect, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Pick Puzzles\nHere',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.white.withOpacity(0.6),
              offset: const Offset(0, 0),
              blurRadius: 8,
            ),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}





