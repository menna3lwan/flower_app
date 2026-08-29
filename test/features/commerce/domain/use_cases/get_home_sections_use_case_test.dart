import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_type.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_home_sections_use_case.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockHomeRepository repository;
  late GetHomeSectionsUseCase useCase;

  setUp(() {
    repository = MockHomeRepository();
    useCase = GetHomeSectionsUseCase(repository);
  });

  test('delegates to HomeRepository.getHomeSections and forwards success',
      () async {
    const sections = [
      HomeSectionEntity(
        id: '1',
        type: HomeSectionType.categories,
        order: 0,
        isActive: true,
      ),
    ];
    when(repository.getHomeSections())
        .thenAnswer((_) async => const Result.success(sections));

    final result = await useCase(const NoParams());

    expect(result.isSuccess, isTrue);
    result.fold(
      (failure) => fail('expected success, got $failure'),
      (data) => expect(data, sections),
    );
  });

  test('forwards a repository failure unchanged', () async {
    when(repository.getHomeSections())
        .thenAnswer((_) async => const Result.failure(ServerFailure()));

    final result = await useCase(const NoParams());

    expect(result.isFailure, isTrue);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
