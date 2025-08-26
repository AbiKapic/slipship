import 'package:flutter/material.dart';
import 'package:shipslip/dependencies.dart';
import 'package:shipslip/flavor/flavor_banner.dart';
import 'package:shipslip/flavor/flavor_config.dart';
import 'package:shipslip/flavor/flavor_config_dev.dart';
import 'package:shipslip/routes/app_pages.dart';
import 'package:shipslip/routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: getIt<FlavorConfig>() is FlavorConfigDev ? 'ShipSlip Dev' : 'ShipSlip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: AppPages.routes,
      initialRoute: AppRoutes.initial,
      builder: (context, child) => FlavorBanner(child!),
    );
  }
}
