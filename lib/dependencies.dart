import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependencies.config.dart';
import 'flavor/flavor_config.dart';
import 'flavor/flavor_config_dev.dart';
import 'flavor/flavor_config_prod.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: false)
Future<void> configureDependencies(String environment) async {
  init(getIt, environment: environment);

  if (environment == 'dev') {
    getIt.registerFactory<FlavorConfig>(() => getIt<FlavorConfigDev>());
  } else {
    getIt.registerFactory<FlavorConfig>(() => getIt<FlavorConfigProd>());
  }
}
