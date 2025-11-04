import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shipslip/features/initial/widgets/icicle_painter.dart';

class FrozenText extends HookWidget {
  const FrozenText({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final dripController = useAnimationController(duration: const Duration(seconds: 4));
    final sparkleController = useAnimationController(duration: const Duration(seconds: 2));

    final dripAnimation = useAnimation(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: dripController, curve: Curves.easeInOut)),
    );

    final sparkleAnimation = useAnimation(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: sparkleController, curve: Curves.easeInOut)),
    );

    useEffect(() {
      dripController.repeat();
      sparkleController.repeat(reverse: true);
      return null;
    }, []);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 50),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Stack(
                children: [
                  Text(
                    text,
                    style: style.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = const Color(0xFF1a365d),
                    ),
                  ),
                  Text(
                    text,
                    style: style.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = const Color(0xFF2563eb),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: const [
                        Color(0xFFffffff),
                        Color(0xFFe0f2fe),
                        Color(0xFFb3e5fc),
                        Color(0xFF81d4fa),
                        Color(0xFF4fc3f7),
                        Color(0xFFffffff),
                      ],
                      stops: const [0.0, 0.15, 0.35, 0.55, 0.75, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      text,
                      style: style.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Color(0xFF0288d1),
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            offset: const Offset(0, 0),
                            blurRadius: 8,
                          ),
                          const Shadow(
                            color: Color(0xFF29b6f6),
                            offset: Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: IceTexturePainter(sparkleAnimation),
                    child: Text(text, style: style.copyWith(color: Colors.transparent)),
                  ),
                ],
              ),
              Positioned(
                bottom: -45,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 50,
                  child: CustomPaint(painter: IciclePainter(dripAnimation), child: Container()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IceDripPainter extends CustomPainter {
  final double animation;
  final Random random = Random(123);

  IceDripPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final dripPaint = Paint()
      ..color = const Color(0xFFe1f5fe).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final dripShadowPaint = Paint()
      ..color = const Color(0xFF0288d1).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final startX = (i + 1) * (size.width / 9) + random.nextDouble() * 20 - 10;
      final baseY = size.height - 10;
      final dripLength = (20 + random.nextDouble() * 25) * animation;
      final dripWidth = 3 + random.nextDouble() * 4;

      final dripPath = Path();
      dripPath.moveTo(startX, baseY);
      dripPath.quadraticBezierTo(
        startX - dripWidth / 2,
        baseY + dripLength * 0.3,
        startX,
        baseY + dripLength * 0.6,
      );
      dripPath.quadraticBezierTo(
        startX + dripWidth / 2,
        baseY + dripLength * 0.8,
        startX,
        baseY + dripLength,
      );
      dripPath.quadraticBezierTo(
        startX - dripWidth / 2,
        baseY + dripLength * 0.8,
        startX,
        baseY + dripLength * 0.6,
      );
      dripPath.quadraticBezierTo(startX + dripWidth / 2, baseY + dripLength * 0.3, startX, baseY);
      dripPath.close();

      canvas.drawPath(dripPath, dripShadowPaint);
      canvas.drawPath(dripPath, dripPaint);

      final highlight = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final highlightPath = Path();
      highlightPath.moveTo(startX - 1, baseY);
      highlightPath.quadraticBezierTo(
        startX - 1,
        baseY + dripLength * 0.5,
        startX - 1,
        baseY + dripLength * 0.8,
      );

      canvas.drawPath(highlightPath, highlight);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class IceTexturePainter extends CustomPainter {
  final double animation;
  final Random random = Random(456);

  IceTexturePainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final icePaint = Paint()
      ..color = Colors.white.withOpacity(0.4 + animation * 0.3)
      ..style = PaintingStyle.fill;

    final crackPaint = Paint()
      ..color = const Color(0xFF29b6f6).withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;

      canvas.drawCircle(Offset(x, y), radius, icePaint);
    }

    for (int i = 0; i < 12; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = startX + (random.nextDouble() - 0.5) * 30;
      final endY = startY + (random.nextDouble() - 0.5) * 20;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), crackPaint);
    }

    final sparkleOpacity = (sin(animation * 2 * pi) + 1) / 2;
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(sparkleOpacity * 0.8)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final sparkleSize = random.nextDouble() * 2 + 0.5;

      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: sparkleSize, height: sparkleSize),
        sparklePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
