import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SnowAnimation extends HookWidget {
  const SnowAnimation({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ticker = useSingleTickerProvider();
    final particles = useRef<List<SnowParticle>>([]);
    final lastTime = useRef<Duration?>(null);
    final animationTicker = useRef<Ticker?>(null);
    final repaintNotifier = useState(0);

    final screenSize = MediaQuery.of(context).size;

    useEffect(() {
      final random = Random();

      final titleAreaWidth = screenSize.width * 0.6;
      final titleAreaCenterX = screenSize.width / 2;
      final titleAreaTopY = screenSize.height * 0.15;

      particles.value = List.generate(30, (index) {
        return SnowParticle(
          x: titleAreaCenterX + (random.nextDouble() - 0.5) * titleAreaWidth,
          y: titleAreaTopY + random.nextDouble() * 50,
          size: random.nextDouble() * 4 + 1,
          speed: random.nextDouble() * 2 + 0.5,
          opacity: random.nextDouble() * 0.7 + 0.3,
          drift: (random.nextDouble() - 0.5) * 0.5,
          color: _getRandomSnowColor(random),
          rotation: random.nextDouble() * 2 * pi,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.02,
        );
      });

      void updateAnimation(Duration elapsed) {
        if (lastTime.value != null) {
          final deltaTime = (elapsed - lastTime.value!).inMilliseconds / 16.0;

          for (var particle in particles.value) {
            particle.update(screenSize.height, screenSize.width, deltaTime);
          }

          repaintNotifier.value = repaintNotifier.value + 1;
        }
        lastTime.value = elapsed;
      }

      animationTicker.value = ticker.createTicker(updateAnimation);
      animationTicker.value!.start();

      return () {
        animationTicker.value?.dispose();
      };
    }, [screenSize.width, screenSize.height]);

    return RepaintBoundary(
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: SnowPainter(particles.value, repaintNotifier.value),
                size: screenSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRandomSnowColor(Random random) {
    final colors = [
      Colors.white,
      const Color(0xFFf0f8ff),
      const Color(0xFFe6f3ff),
      const Color(0xFFd1ecff),
      const Color(0xFFb8dfff),
    ];
    return colors[random.nextInt(colors.length)];
  }
}

class SnowParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double drift;
  final Color color;
  double rotation;
  final double rotationSpeed;

  SnowParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
  });

  void update(double screenHeight, double screenWidth, double deltaTime) {
    y += speed * deltaTime;
    x += drift * deltaTime;
    rotation += rotationSpeed * deltaTime;

    if (y > screenHeight + size) {
      y = -size;
      final titleAreaWidth = screenWidth * 0.6;
      final titleAreaCenterX = screenWidth / 2;
      x = titleAreaCenterX + (Random().nextDouble() - 0.5) * titleAreaWidth;
    }

    if (x > screenWidth + size) {
      x = -size;
    } else if (x < -size) {
      x = screenWidth + size;
    }
  }
}

class SnowPainter extends CustomPainter {
  final List<SnowParticle> particles;
  final int repaintTrigger;

  SnowPainter(this.particles, this.repaintTrigger);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
        ..style = PaintingStyle.fill;

      final mainPaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset.zero, particle.size + 1.5, glowPaint);
      canvas.drawCircle(Offset.zero, particle.size, mainPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant SnowPainter oldDelegate) =>
      repaintTrigger != oldDelegate.repaintTrigger;
}
