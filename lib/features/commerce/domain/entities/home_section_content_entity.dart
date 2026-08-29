import 'package:equatable/equatable.dart';

import 'package:customer_app/core/domain/entities/product_entity.dart';
import 'category_entity.dart';
import 'occasion_entity.dart';

/// Per-section hydration outcome — lets Home render successful sections while a sibling section failed (partial failure).
enum HomeSectionLoadStatus { success, empty, failed, unsupported }

/// A [HomeSectionEntity] after its content has been fetched via the matching Catalog use case; one sealed subtype per known [HomeSectionType].
sealed class HomeSectionContentEntity extends Equatable {
  const HomeSectionContentEntity({
    required this.id,
    required this.order,
    required this.title,
    required this.status,
  });

  final String id;
  final int order;
  final String? title;
  final HomeSectionLoadStatus status;
}

final class CategoriesSectionContent extends HomeSectionContentEntity {
  const CategoriesSectionContent({
    required super.id,
    required super.order,
    super.title,
    required super.status,
    this.categories = const [],
  });

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [id, order, title, status, categories];
}

final class OccasionsSectionContent extends HomeSectionContentEntity {
  const OccasionsSectionContent({
    required super.id,
    required super.order,
    super.title,
    required super.status,
    this.occasions = const [],
  });

  final List<OccasionEntity> occasions;

  @override
  List<Object?> get props => [id, order, title, status, occasions];
}

final class BestSellerSectionContent extends HomeSectionContentEntity {
  const BestSellerSectionContent({
    required super.id,
    required super.order,
    super.title,
    required super.status,
    this.products = const [],
  });

  final List<ProductEntity> products;

  @override
  List<Object?> get props => [id, order, title, status, products];
}

final class ProductsCarouselSectionContent extends HomeSectionContentEntity {
  const ProductsCarouselSectionContent({
    required super.id,
    required super.order,
    super.title,
    required super.status,
    this.products = const [],
    this.occasionId,
    this.categoryId,
  });

  final List<ProductEntity> products;
  final String? occasionId;
  final String? categoryId;

  @override
  List<Object?> get props =>
      [id, order, title, status, products, occasionId, categoryId];
}

/// A section whose `type` this app version doesn't recognize — carried through so the registry/tests can assert it's skipped gracefully, never rendered.
final class UnsupportedSectionContent extends HomeSectionContentEntity {
  const UnsupportedSectionContent({
    required super.id,
    required super.order,
    super.title,
  }) : super(status: HomeSectionLoadStatus.unsupported);

  @override
  List<Object?> get props => [id, order, title, status];
}
