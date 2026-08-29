import 'package:equatable/equatable.dart';

import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// The server returned zero active sections — a valid response, distinct from [HomeError].
final class HomeEmpty extends HomeState {
  const HomeEmpty();
}

final class HomeError extends HomeState {
  const HomeError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.sections,
    this.isRefreshing = false,
    this.refreshFailure,
  });

  final List<HomeSectionContentEntity> sections;
  final bool isRefreshing;

  /// One-shot: set right after a failed pull-to-refresh so the view can show a snackbar, then cleared via [HomeCubit.consumeRefreshFailure].
  final Failure? refreshFailure;

  HomeLoaded copyWith({
    List<HomeSectionContentEntity>? sections,
    bool? isRefreshing,
    Failure? refreshFailure,
    bool clearRefreshFailure = false,
  }) {
    return HomeLoaded(
      sections: sections ?? this.sections,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      refreshFailure:
          clearRefreshFailure ? null : (refreshFailure ?? this.refreshFailure),
    );
  }

  @override
  List<Object?> get props => [sections, isRefreshing, refreshFailure];
}
