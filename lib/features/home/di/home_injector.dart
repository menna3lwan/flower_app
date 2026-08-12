import '../../../core/di/injector.dart';
import '../presentation/cubit/home_cubit.dart';

/// Registers the Home feature's [HomeCubit]; depends on `CatalogRepository`, so must run after the catalog registrar.
void setupHomeDependencies() {
  sl.registerFactory(() => HomeCubit(sl()));
}
