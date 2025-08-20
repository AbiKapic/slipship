import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  static const String route = '/';
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/start');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}


