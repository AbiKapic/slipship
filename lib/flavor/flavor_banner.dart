import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipslip/dependencies.dart';

import 'package:shipslip/flavor/flavor_config.dart';
import 'package:shipslip/flavor/flavor_config_dev.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      kDebugMode || getIt<FlavorConfig>() is FlavorConfigDev
          ? Banner(
              location: BannerLocation.topStart,
              message:
                  getIt<FlavorConfig>() is FlavorConfigDev ? 'DEV' : 'PROD',
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0,
              ),
              child: child,
            )
          : Container(child: child);
}

