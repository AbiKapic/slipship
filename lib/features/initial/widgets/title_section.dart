import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 280),
          child: Image.asset(
            'assets/images/slipship_title.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            color: const Color(0xFFE6F3FF).withOpacity(0.95),
            colorBlendMode: BlendMode.modulate,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Navigate • Solve • Conquer',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.white.withOpacity(0.3),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A puzzle adventure awaits',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            shadows: [
              Shadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
