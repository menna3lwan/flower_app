import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/ui/home/manager/home_cubit.dart';
import 'package:customer_app/features/commerce/ui/home/manager/home_state.dart';

import '../../../../support/mocks.dart';

const _section = CategoriesSectionContent(
  id: '1',
  order: 0,
  status: HomeSectionLoadStatus.success,
  categories: [],
);

void main() {
  late MockLoadHomeUseCase loadHome;
  late HomeCubit cubit;

  setUp(() {
    loadHome = MockLoadHomeUseCase();
    cubit = HomeCubit(loadHome);
  });

  test('starts as HomeInitial', () {
    expect(cubit.state, const HomeInitial());
  });

  group('loadHome', () {
    test('goes Loading -> Loaded on success', () async {
      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.success([_section]));

      final states = <HomeState>[];
      cubit.stream.listen(states.add);

      await cubit.loadHome();
      await Future<void>.delayed(Duration.zero);

      expect(states, hasLength(2));
      expect(states[0], const HomeLoading());
      expect(states[1], isA<HomeLoaded>());
      expect((states[1] as HomeLoaded).sections, [_section]);
    });

    test('an empty section list emits HomeEmpty, not HomeError', () async {
      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.success([]));

      await cubit.loadHome();

      expect(cubit.state, const HomeEmpty());
    });

    test('a repository/use case failure emits HomeError with the Failure',
        () async {
      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.failure(NetworkFailure()));

      await cubit.loadHome();

      expect(cubit.state, isA<HomeError>());
      expect((cubit.state as HomeError).failure, isA<NetworkFailure>());
    });
  });

  group('refreshHome', () {
    test('keeps the previously loaded sections when the refresh call fails',
        () async {
      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.success([_section]));
      await cubit.loadHome();

      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.failure(ServerFailure()));
      await cubit.refreshHome();

      final state = cubit.state as HomeLoaded;
      expect(state.sections, [_section]);
      expect(state.isRefreshing, isFalse);
      expect(state.refreshFailure, isA<ServerFailure>());
    });

    test('a failed refresh keeps the pre-await snapshot if loadHome overlaps',
        () async {
      final refreshGate =
          Completer<Result<List<HomeSectionContentEntity>>>();
      final overlappingLoadGate =
          Completer<Result<List<HomeSectionContentEntity>>>();
      var calls = 0;
      when(loadHome(const NoParams())).thenAnswer((_) async {
        calls++;
        if (calls == 1) return const Result.success([_section]);
        if (calls == 2) return refreshGate.future;
        return overlappingLoadGate.future;
      });

      await cubit.loadHome();
      expect(cubit.state, isA<HomeLoaded>());

      final refreshFuture = cubit.refreshHome();
      await Future<void>.delayed(Duration.zero);

      final overlappingLoad = cubit.loadHome();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, const HomeLoading());

      refreshGate.complete(const Result.failure(ServerFailure()));
      await refreshFuture;

      final state = cubit.state as HomeLoaded;
      expect(state.sections, [_section]);
      expect(state.refreshFailure, isA<ServerFailure>());

      overlappingLoadGate.complete(const Result.success([_section]));
      await overlappingLoad;
    });

    test('consumeRefreshFailure clears the one-shot failure', () async {
      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.success([_section]));
      await cubit.loadHome();
      when(loadHome(const NoParams()))
          .thenAnswer((_) async => const Result.failure(ServerFailure()));
      await cubit.refreshHome();

      cubit.consumeRefreshFailure();

      expect((cubit.state as HomeLoaded).refreshFailure, isNull);
    });
  });
}
