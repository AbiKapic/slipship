import 'package:flutter/material.dart';
import 'package:shipslip/dependencies.dart';
import 'package:shipslip/flavor/flavor_config.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final flavorConfig = getIt<FlavorConfig>();

    return Column(
      children: [
        // Main title with gradient effect
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            flavorConfig.appName,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Subtitle
        Text(
          'Navigate • Solve • Conquer',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          'A puzzle adventure awaits',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

