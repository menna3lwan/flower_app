import 'package:equatable/equatable.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/occasion_entity.dart';
import '../../../domain/entities/product_item_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.categories,
    required this.bestSellers,
    required this.occasions,
  });

  final List<CategoryEntity> categories;
  final List<ProductItemEntity> bestSellers;
  final List<OccasionEntity> occasions;

  @override
  List<Object?> get props => [categories, bestSellers, occasions];
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
