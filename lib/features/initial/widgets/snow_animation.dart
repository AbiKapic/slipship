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

      particles.value = List.generate(20, (index) {
        return SnowParticle(
          x: random.nextDouble() * screenSize.width,
          y: random.nextDouble() * screenSize.height,
          size: random.nextDouble() * 4 + 1,
          speed: random.nextDouble() * 2 + 0.5,
          opacity: random.nextDouble() * 0.6 + 0.2,
          drift: (random.nextDouble() - 0.5) * 0.5,
          color: _getRandomSnowColor(random),
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
      child: CustomPaint(
        painter: SnowPainter(particles.value, repaintNotifier.value),
        child: child,
      ),
    );
  }

  Color _getRandomSnowColor(Random random) {
    final colors = [
      Colors.white.withOpacity(0.8),
      const Color(0xFFf0f8ff).withOpacity(0.7),
      const Color(0xFFe6f3ff).withOpacity(0.6),
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

  SnowParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
    required this.color,
  });

  void update(double screenHeight, double screenWidth, double deltaTime) {
    y += speed * deltaTime;
    x += drift * deltaTime;

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
}

class SnowPainter extends CustomPainter {
  final List<SnowParticle> particles;
  final int repaintTrigger;

  SnowPainter(this.particles, this.repaintTrigger);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SnowPainter oldDelegate) =>
      repaintTrigger != oldDelegate.repaintTrigger;
}
