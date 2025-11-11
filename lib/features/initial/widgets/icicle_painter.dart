import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class IciclePainter extends CustomPainter {
  final double animation;
  final Random random = Random(789);

  IciclePainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 12; i++) {
      final startX = (i + 0.5) * (size.width / 12) + random.nextDouble() * 15 - 7.5;
      final baseY = size.height - 5;
      final icicleLength = (15 + random.nextDouble() * 35) * animation;
      final icicleWidth = 2 + random.nextDouble() * 6;

      final icicleGradient = LinearGradient(
        colors: [
          const Color(0xFFffffff).withOpacity(0.95),
          const Color(0xFFe1f5fe).withOpacity(0.9),
          const Color(0xFFb3e5fc).withOpacity(0.85),
          const Color(0xFF81d4fa).withOpacity(0.8),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

      final iciclePaint = Paint()
        ..shader = icicleGradient.createShader(
          Rect.fromLTWH(startX - icicleWidth / 2, baseY, icicleWidth, icicleLength),
        )
        ..style = PaintingStyle.fill;

      final icicleShadow = Paint()
        ..color = const Color(0xFF0288d1).withOpacity(0.4)
        ..style = PaintingStyle.fill;

      final iciclePath = Path();
      iciclePath.moveTo(startX - icicleWidth / 2, baseY);
      iciclePath.lineTo(startX + icicleWidth / 2, baseY);

      final segments = 8;
      for (int j = 1; j <= segments; j++) {
        final progress = j / segments;
        final currentY = baseY + icicleLength * progress;
        final currentWidth = icicleWidth * (1 - progress * 0.9);
        final wobble = sin(progress * pi * 3) * 2 * (1 - progress);

        if (j == segments) {
          iciclePath.lineTo(startX, currentY);
        } else {
          iciclePath.lineTo(startX + currentWidth / 2 + wobble, currentY);
        }
      }

      for (int j = segments - 1; j >= 1; j--) {
        final progress = j / segments;
        final currentY = baseY + icicleLength * progress;
        final currentWidth = icicleWidth * (1 - progress * 0.9);
        final wobble = sin(progress * pi * 3) * 2 * (1 - progress);

        iciclePath.lineTo(startX - currentWidth / 2 + wobble, currentY);
      }

      iciclePath.close();

      canvas.drawPath(_offsetPath(iciclePath, const Offset(1, 1)), icicleShadow);
      canvas.drawPath(iciclePath, iciclePaint);

      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final highlightPath = Path();
      highlightPath.moveTo(startX - icicleWidth / 4, baseY);
      for (int j = 1; j <= segments; j++) {
        final progress = j / segments;
        final currentY = baseY + icicleLength * progress;
        final currentWidth = icicleWidth * (1 - progress * 0.9);
        final wobble = sin(progress * pi * 3) * 2 * (1 - progress);

        if (j == segments) {
          highlightPath.lineTo(startX - 1, currentY - 2);
        } else {
          highlightPath.lineTo(startX + currentWidth / 4 + wobble - 1, currentY);
        }
      }

      canvas.drawPath(highlightPath, highlightPaint);

      if (animation > 0.7) {
        final dropSize = 2 + random.nextDouble() * 3;
        final dropY = baseY + icicleLength + 5 + sin(animation * pi * 2) * 3;

        final dropGradient = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            const Color(0xFFb3e5fc).withOpacity(0.7),
            const Color(0xFF0288d1).withOpacity(0.5),
          ],
        );

        final dropPaint = Paint()
          ..shader = dropGradient.createShader(
            Rect.fromCircle(center: Offset(startX, dropY), radius: dropSize),
          );

        canvas.drawCircle(Offset(startX, dropY), dropSize, dropPaint);

        final dropHighlight = Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(startX - dropSize / 3, dropY - dropSize / 3),
          dropSize / 3,
          dropHighlight,
        );
      }
    }
  }

  Path _offsetPath(Path path, Offset offset) {
    final matrix = Matrix4.identity();
    matrix.translate(offset.dx, offset.dy);
    return path.transform(matrix.storage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
