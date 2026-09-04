import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/features/commerce/data/data_sources/remote/dev/local_mock_home_remote_data_source.dart';
import 'package:customer_app/features/commerce/data/repositories/home_repository_impl.dart';

void main() {
  late LocalMockHomeRemoteDataSource dataSource;

  setUp(() {
    dataSource = LocalMockHomeRemoteDataSource();
  });

  group('LocalMockHomeRemoteDataSource', () {
    test('returns a fixed dataset with no network dependency', () async {
      final first = await dataSource.getHomeSections();
      final second = await dataSource.getHomeSections();

      expect(first, isNotEmpty);
      expect(first.map((s) => s.id), second.map((s) => s.id));
    });

    test('includes exactly one inactive section', () async {
      final sections = await dataSource.getHomeSections();

      expect(sections.where((s) => !s.isActive), hasLength(1));
    });

    test('includes an unrecognized type to exercise the unsupported path',
        () async {
      final sections = await dataSource.getHomeSections();

      expect(sections.any((s) => s.type == 'FlashSale'), isTrue);
    });

    test('covers every known section type exactly once among active entries',
        () async {
      final sections = await dataSource.getHomeSections();
      final activeKnownTypes = sections
          .where((s) => s.isActive)
          .map((s) => s.type)
          .where((type) => type != 'FlashSale')
          .toSet();

      expect(
        activeKnownTypes,
        {'Categories', 'Occasions', 'BestSeller', 'ProductsCarousel'},
      );
    });

    test('orders Categories before BestSeller, matching Figma', () async {
      final sections = await dataSource.getHomeSections();
      final categoriesIndex =
          sections.firstWhere((s) => s.type == 'Categories' && s.isActive).index;
      final bestSellerIndex =
          sections.firstWhere((s) => s.type == 'BestSeller').index;

      expect(categoriesIndex, lessThan(bestSellerIndex));
    });
  });

  group('LocalMockHomeRemoteDataSource through HomeRepositoryImpl', () {
    test('drops the inactive section and sorts the rest by order', () async {
      final repository = HomeRepositoryImpl(dataSource);

      final result = await repository.getHomeSections();

      result.fold(
        (failure) => fail('expected success, got $failure'),
        (sections) {
          expect(sections.every((s) => s.isActive), isTrue);
          final orders = sections.map((s) => s.order).toList();
          expect(orders, List.of(orders)..sort());
        },
      );
    });
  });
}
