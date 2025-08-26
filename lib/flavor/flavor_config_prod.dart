import 'package:injectable/injectable.dart';
import 'package:shipslip/flavor/flavor_config.dart';

@Environment(Environment.prod)
@injectable
class FlavorConfigProd extends FlavorConfig {
  @override
  String get appName => 'ShipSlip';

  @override
  String get flavorName => 'prod';

  @override
  bool get isProduction => true;
}

