import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayButton extends HookWidget {
  const PlayButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scaleController = useAnimationController(duration: const Duration(milliseconds: 100));
    final pulseController = useAnimationController(duration: const Duration(milliseconds: 2500));
    final loadingController = useAnimationController(duration: const Duration(milliseconds: 800));
    final rippleController = useAnimationController(duration: const Duration(milliseconds: 600));

    final isLoading = useState(false);

    final scaleAnimation = useAnimation(
      Tween<double>(
        begin: 1.0,
        end: 0.98,
      ).animate(CurvedAnimation(parent: scaleController, curve: Curves.easeOut)),
    );

    final pulseAnimation = useAnimation(
      Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(parent: pulseController, curve: Curves.easeInOut)),
    );

    final loadingRotation = useAnimation(
      Tween<double>(
        begin: 0.0,
        end: 2 * pi,
      ).animate(CurvedAnimation(parent: loadingController, curve: Curves.easeInOut)),
    );

    final rippleScale = useAnimation(
      Tween<double>(
        begin: 1.0,
        end: 1.4,
      ).animate(CurvedAnimation(parent: rippleController, curve: Curves.easeOut)),
    );

    final rippleOpacity = useAnimation(
      Tween<double>(
        begin: 0.6,
        end: 0.0,
      ).animate(CurvedAnimation(parent: rippleController, curve: Curves.easeOut)),
    );

    useEffect(() {
      if (!isLoading.value) {
        pulseController.repeat(reverse: true);
      } else {
        pulseController.stop();
        loadingController.repeat();
        rippleController.repeat();
      }
      return null;
    }, [isLoading.value]);

    void onTapDown(TapDownDetails details) {
      if (!isLoading.value) {
        scaleController.forward();
      }
    }

    void onTapUp(TapUpDetails details) {
      if (!isLoading.value) {
        scaleController.reverse();
      }
    }

    void onTapCancel() {
      if (!isLoading.value) {
        scaleController.reverse();
      }
    }

    void handlePress() {
      if (!isLoading.value) {
        isLoading.value = true;
        onPressed();
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isLoading.value) ...[
          Transform.scale(
            scale: rippleScale,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF87CEEB).withOpacity(rippleOpacity),
                  width: 3,
                ),
              ),
            ),
          ),
          Transform.scale(
            scale: rippleScale * 0.7,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFB3D9FF).withOpacity(rippleOpacity * 0.8),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
        Transform.scale(
          scale: scaleAnimation * (isLoading.value ? 1.0 : pulseAnimation),
          child: GestureDetector(
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onTapCancel: onTapCancel,
            onTap: handlePress,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isLoading.value
                      ? [
                          const Color(0xFFE6F3FF),
                          const Color(0xFFB3D9FF),
                          const Color(0xFF87CEEB),
                          const Color(0xFF6BB6D6),
                        ]
                      : [
                          const Color(0xFFFFFFFF),
                          const Color(0xFFE6F3FF),
                          const Color(0xFFB3D9FF),
                          const Color(0xFF87CEEB),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF87CEEB).withOpacity(isLoading.value ? 0.9 : 0.6),
                    blurRadius: isLoading.value ? 50 : 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFFB3D9FF).withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: isLoading.value
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: loadingRotation,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF2E5B8A), width: 4),
                                gradient: SweepGradient(
                                  colors: [
                                    const Color(0xFF2E5B8A).withOpacity(0.1),
                                    const Color(0xFF2E5B8A),
                                    const Color(0xFF2E5B8A).withOpacity(0.1),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE6F3FF),
                            ),
                            child: const Icon(
                              Icons.hourglass_empty_rounded,
                              size: 24,
                              color: Color(0xFF2E5B8A),
                            ),
                          ),
                        ],
                      )
                    : const Icon(Icons.play_arrow_rounded, size: 70, color: Color(0xFF2E5B8A)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
