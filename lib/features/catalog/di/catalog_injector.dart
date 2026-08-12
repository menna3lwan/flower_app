import '../../../core/di/injector.dart';
import '../data/datasources/catalog_local_data_source.dart';
import '../data/repositories/catalog_repository_impl.dart';
import '../domain/repositories/catalog_repository.dart';

/// Registers the catalog feature's data source and repository; must run before any registrar needing `CatalogRepository`.
void setupCatalogDependencies() {
  sl
    ..registerLazySingleton<CatalogLocalDataSource>(CatalogLocalDataSourceImpl.new)
    ..registerLazySingleton<CatalogRepository>(() => CatalogRepositoryImpl(sl()));
}
