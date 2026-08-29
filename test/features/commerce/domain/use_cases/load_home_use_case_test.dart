import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/domain/entities/product_entity.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/category_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_type.dart';
import 'package:customer_app/features/commerce/domain/use_cases/load_home_use_case.dart';

import '../../../../support/mocks.dart';

const _category = CategoryEntity(id: 'c1', name: 'Roses', iconName: 'local_florist');
const _product = ProductEntity(id: 'p1', name: 'Bouquet', imageUrl: '', price: 100);

void main() {
  late MockGetHomeSectionsUseCase getHomeSections;
  late MockGetCategoriesUseCase getCategories;
  late MockGetOccasionsUseCase getOccasions;
  late MockGetBestSellersUseCase getBestSellers;
  late MockGetProductsByOccasionUseCase getProductsByOccasion;
  late MockGetProductsByCategoryUseCase getProductsByCategory;
  late LoadHomeUseCase useCase;

  setUp(() {
    getHomeSections = MockGetHomeSectionsUseCase();
    getCategories = MockGetCategoriesUseCase();
    getOccasions = MockGetOccasionsUseCase();
    getBestSellers = MockGetBestSellersUseCase();
    getProductsByOccasion = MockGetProductsByOccasionUseCase();
    getProductsByCategory = MockGetProductsByCategoryUseCase();
    useCase = LoadHomeUseCase(
      getHomeSections,
      getCategories,
      getOccasions,
      getBestSellers,
      getProductsByOccasion,
      getProductsByCategory,
    );
  });

  test('a failed /home/sections call fails the whole Home load', () async {
    when(getHomeSections(const NoParams()))
        .thenAnswer((_) async => const Result.failure(ServerFailure()));

    final result = await useCase(const NoParams());

    expect(result.isFailure, isTrue);
  });

  test('an empty section list returns an empty (not failed) content list',
      () async {
    when(getHomeSections(const NoParams()))
        .thenAnswer((_) async => const Result.success([]));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) => expect(sections, isEmpty),
    );
  });

  test('hydrates every known section type from its matching Catalog use case',
      () async {
    when(getHomeSections(const NoParams())).thenAnswer((_) async => const Result.success([
          HomeSectionEntity(id: '1', type: HomeSectionType.categories, order: 0, isActive: true),
          HomeSectionEntity(id: '2', type: HomeSectionType.bestSeller, order: 1, isActive: true),
        ]));
    when(getCategories(const NoParams()))
        .thenAnswer((_) async => const Result.success([_category]));
    when(getBestSellers(const NoParams()))
        .thenAnswer((_) async => const Result.success([_product]));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) {
        expect(sections, hasLength(2));
        final categories = sections[0] as CategoriesSectionContent;
        expect(categories.status, HomeSectionLoadStatus.success);
        expect(categories.categories, [_category]);
        final bestSeller = sections[1] as BestSellerSectionContent;
        expect(bestSeller.status, HomeSectionLoadStatus.success);
      },
    );
  });

  test('one failed section does not fail its siblings (partial failure)',
      () async {
    when(getHomeSections(const NoParams())).thenAnswer((_) async => const Result.success([
          HomeSectionEntity(id: '1', type: HomeSectionType.categories, order: 0, isActive: true),
          HomeSectionEntity(id: '2', type: HomeSectionType.occasions, order: 1, isActive: true),
        ]));
    when(getCategories(const NoParams()))
        .thenAnswer((_) async => const Result.success([_category]));
    when(getOccasions(const NoParams()))
        .thenAnswer((_) async => const Result.failure(NetworkFailure()));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) {
        expect(sections, hasLength(2));
        expect(sections[0].status, HomeSectionLoadStatus.success);
        expect(sections[1].status, HomeSectionLoadStatus.failed);
      },
    );
  });

  test('an empty Catalog result marks the section empty, not failed',
      () async {
    when(getHomeSections(const NoParams())).thenAnswer((_) async => const Result.success([
          HomeSectionEntity(id: '1', type: HomeSectionType.categories, order: 0, isActive: true),
        ]));
    when(getCategories(const NoParams()))
        .thenAnswer((_) async => const Result.success([]));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) => expect(sections.single.status, HomeSectionLoadStatus.empty),
    );
  });

  test('an unknown section type is dropped, not rendered as a gap', () async {
    when(getHomeSections(const NoParams())).thenAnswer((_) async => const Result.success([
          HomeSectionEntity(id: '1', type: HomeSectionType.unknown, order: 0, isActive: true),
          HomeSectionEntity(id: '2', type: HomeSectionType.bestSeller, order: 1, isActive: true),
        ]));
    when(getBestSellers(const NoParams()))
        .thenAnswer((_) async => const Result.success([_product]));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) {
        expect(sections, hasLength(1));
        expect(sections.single, isA<BestSellerSectionContent>());
      },
    );
  });

  test('ProductsCarousel with occasionId calls getProductsByOccasion',
      () async {
    when(getHomeSections(const NoParams())).thenAnswer((_) async => const Result.success([
          HomeSectionEntity(
            id: '1',
            type: HomeSectionType.productsCarousel,
            order: 0,
            isActive: true,
            occasionId: 'o1',
          ),
        ]));
    when(getProductsByOccasion('o1'))
        .thenAnswer((_) async => const Result.success([_product]));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) {
        final carousel = sections.single as ProductsCarouselSectionContent;
        expect(carousel.status, HomeSectionLoadStatus.success);
        expect(carousel.products, [_product]);
      },
    );
    verifyNever(getProductsByCategory(any as dynamic));
  });

  test('a ProductsCarousel section with neither filter id fails gracefully',
      () async {
    when(getHomeSections(const NoParams())).thenAnswer((_) async => const Result.success([
          HomeSectionEntity(
            id: '1',
            type: HomeSectionType.productsCarousel,
            order: 0,
            isActive: true,
          ),
        ]));

    final result = await useCase(const NoParams());

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) => expect(sections.single.status, HomeSectionLoadStatus.failed),
    );
    verifyNever(getProductsByOccasion(any as dynamic));
    verifyNever(getProductsByCategory(any as dynamic));
  });
}
