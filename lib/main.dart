import 'package:flutter/material.dart';
import 'package:shipslip/app.dart';
import 'package:shipslip/dependencies.dart';

Future<void> runFlavoredApp(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(environment);

  runApp(const App());
}
