import 'package:flutter/material.dart';
import 'package:shipslip/services/progress_service.dart';

class PuzzleScreen extends StatefulWidget {
  static const String route = '/puzzle';
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final ProgressService _progress = ProgressService();
  int _pieces = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pieces = await _progress.getPiecesCollected();
    if (mounted) {
      setState(() {
        _pieces = pieces;
        _loading = false;
      });
    }
  }

  Future<void> _reset() async {
    await _progress.reset();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final complete = _pieces >= 9;
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 240,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final filled = index < _pieces;
                    return DecoratedBox(
                      decoration: ShapeDecoration(
                        color: filled ? Colors.teal : Colors.grey.shade300,
                        shape: const StadiumBorder(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (complete) ...[
              const Text(
                'Complete!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FilledButton(onPressed: _reset, child: const Text('Reset')),
            ],
          ],
        ),
      ),
    );
  }
}
