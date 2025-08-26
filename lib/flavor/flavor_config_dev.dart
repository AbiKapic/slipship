import 'package:injectable/injectable.dart';
import 'package:shipslip/flavor/flavor_config.dart';

@Environment(Environment.dev)
@injectable
class FlavorConfigDev extends FlavorConfig {
  @override
  String get appName => 'ShipSlip Dev';

  @override
  String get flavorName => 'dev';

  @override
  bool get isProduction => false;
}

