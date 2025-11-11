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

import 'flavor/flavor_config_dev.dart' as _i465;
import 'flavor/flavor_config_prod.dart' as _i219;

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
  gh.factory<_i219.FlavorConfigProd>(
    () => _i219.FlavorConfigProd(),
    registerFor: {_prod},
  );
  return getIt;
}
