import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'routes.dart';

/// Main app widget
class SnowBridgeRunnerApp extends StatelessWidget {
  const SnowBridgeRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    return MaterialApp(
      title: 'Snow Bridge Runner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
