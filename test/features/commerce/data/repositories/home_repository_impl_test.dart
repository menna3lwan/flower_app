import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/features/commerce/data/models/home_section_dto.dart';
import 'package:customer_app/features/commerce/data/repositories/home_repository_impl.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockHomeRemoteDataSource dataSource;
  late HomeRepositoryImpl repository;

  setUp(() {
    dataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(dataSource);
  });

  test('filters out inactive sections and sorts by order', () async {
    when(dataSource.getHomeSections()).thenAnswer((_) async => const [
          HomeSectionDto(
              id: 2, type: 'BestSeller', index: 1, isActive: true),
          HomeSectionDto(
              id: 1, type: 'Categories', index: 0, isActive: true),
          HomeSectionDto(
              id: 3, type: 'Occasions', index: 2, isActive: false),
        ]);

    final result = await repository.getHomeSections();

    expect(result.isSuccess, isTrue);
    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) {
        expect(sections, hasLength(2));
        expect(sections[0].id, '1');
        expect(sections[1].id, '2');
      },
    );
  });

  test('turns a thrown ServerException into a ServerFailure via safeCall',
      () async {
    when(dataSource.getHomeSections())
        .thenThrow(const ServerException('Failed to load home sections.'));

    final result = await repository.getHomeSections();

    expect(result.isFailure, isTrue);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('expected failure'),
    );
  });

  test('empty backend response yields an empty (not failed) list', () async {
    when(dataSource.getHomeSections()).thenAnswer((_) async => const []);

    final result = await repository.getHomeSections();

    result.fold(
      (failure) => fail('expected success, got $failure'),
      (sections) => expect(sections, isEmpty),
    );
  });
}
