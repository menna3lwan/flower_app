import 'package:customer_app/core/result/result.dart';
import '../entities/home_section_entity.dart';

/// Home's own layout-config contract — separate from CatalogRepository, which owns catalog content (categories/occasions/products), not page layout.
abstract interface class HomeRepository {
  Future<Result<List<HomeSectionEntity>>> getHomeSections();
}
