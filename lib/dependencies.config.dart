// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'flavor/flavor_config.dart' as _i467;
import 'flavor/flavor_config_dev.dart' as _i465;
import 'flavor/flavor_config_prod.dart' as _i466;

const String _dev = 'dev';
const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i465.FlavorConfigDev>(
    () => _i465.FlavorConfigDev(),
    registerFor: {_dev},
  );
  gh.factory<_i466.FlavorConfigProd>(
    () => _i466.FlavorConfigProd(),
    registerFor: {_prod},
  );

  // Register the base FlavorConfig interface
  if (environment == _dev) {
    gh.factory<_i467.FlavorConfig>(
      () => _i465.FlavorConfigDev(),
      registerFor: {_dev},
    );
  } else if (environment == _prod) {
    gh.factory<_i467.FlavorConfig>(
      () => _i466.FlavorConfigProd(),
      registerFor: {_prod},
    );
  }

  return getIt;
}
