import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shipslip/features/initial/widgets/play_button.dart';
import 'package:shipslip/features/initial/widgets/title_section.dart';
import 'package:shipslip/features/initial/widgets/background_decoration.dart';
import 'package:shipslip/features/initial/widgets/snow_animation.dart';
import 'package:shipslip/features/game/screens/game_screen.dart';

class InitialScreen extends HookWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    final fadeAnimation = useAnimation(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut)),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.elasticOut));

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    return Scaffold(
      body: SnowAnimation(
        child: Container(
          decoration: const BackgroundDecoration().buildDecoration(),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: fadeAnimation,
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 5,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TitleSection(),
                              const SizedBox(height: 60),
                              PlayButton(onPressed: () => _navigateToGame(context)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FutureBuilder(
              future: _preloadGameAssets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const GameScreen();
                } else {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF87CEEB),
                          Color(0xFFB0E0E6),
                          Color(0xFFE0F6FF),
                          Color(0xFFF0F8FF),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E5B8A)),
                      ),
                    ),
                  );
                }
              },
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  Future<void> _preloadGameAssets() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
