import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfessionalFrozenText extends HookWidget {
  const ProfessionalFrozenText({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final glowController = useAnimationController(duration: const Duration(seconds: 3));

    final glowAnimation = useAnimation(
      Tween<double>(
        begin: 0.7,
        end: 1.0,
      ).animate(CurvedAnimation(parent: glowController, curve: Curves.easeInOut)),
    );

    useEffect(() {
      glowController.repeat(reverse: true);
      return null;
    }, []);

    return SizedBox(
      height: style.fontSize! + 60,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1.5, color: Colors.white.withOpacity(0.3)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.08),
                Colors.blue.withOpacity(0.03),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: glowController,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color.lerp(Colors.white, const Color(0xFFE1F5FE), glowAnimation)!,
                    Color.lerp(const Color(0xFFB3E5FC), const Color(0xFF81D4FA), glowAnimation)!,
                    Color.lerp(const Color(0xFF4FC3F7), Colors.white, glowAnimation)!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  text,
                  style: style.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.6 * glowAnimation),
                        offset: const Offset(0, 0),
                        blurRadius: 12 * glowAnimation,
                      ),
                      Shadow(
                        color: const Color(0xFF4FC3F7).withOpacity(0.4 * glowAnimation),
                        offset: const Offset(0, 2),
                        blurRadius: 8 * glowAnimation,
                      ),
                      Shadow(
                        color: Colors.cyan.withOpacity(0.3 * glowAnimation),
                        offset: const Offset(1, 1),
                        blurRadius: 6 * glowAnimation,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
