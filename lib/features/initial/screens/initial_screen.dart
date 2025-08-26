import 'package:flutter/material.dart';
import 'package:shipslip/dependencies.dart';
import 'package:shipslip/features/initial/widgets/play_button.dart';
import 'package:shipslip/features/initial/widgets/title_section.dart';
import 'package:shipslip/features/initial/widgets/background_decoration.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BackgroundDecoration().buildDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleSection(),
                    const SizedBox(height: 60),
                    PlayButton(onPressed: () => _navigateToGame(context)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(), // Space for additional content
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/game');
  }
}

