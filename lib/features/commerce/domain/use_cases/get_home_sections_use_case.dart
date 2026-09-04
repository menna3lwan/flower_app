import 'package:injectable/injectable.dart';

import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import '../entities/home_section_entity.dart';
import '../repositories/home_repository.dart';

/// Thin wrapper over [HomeRepository.getHomeSections].
@lazySingleton
class GetHomeSectionsUseCase
    implements UseCase<List<HomeSectionEntity>, NoParams> {
  const GetHomeSectionsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<List<HomeSectionEntity>>> call(NoParams params) {
    return _repository.getHomeSections();
  }
}
