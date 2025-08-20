import 'package:flutter/material.dart';
import 'package:shipslip/services/progress_service.dart';

class StartScreen extends StatefulWidget {
  static const String route = '/start';
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final ProgressService _progress = ProgressService();
  int _pieces = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pieces = await _progress.getPiecesCollected();
    if (mounted) {
      setState(() => _pieces = pieces);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('shipslip')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pieces collected: $_pieces / 9'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/game'),
              child: const Text('Play Level 1'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/puzzle'),
              child: const Text('Puzzle Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
