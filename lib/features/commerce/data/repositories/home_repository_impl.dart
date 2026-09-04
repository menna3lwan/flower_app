import 'package:injectable/injectable.dart';

import 'package:customer_app/core/base/safe_call.dart';
import 'package:customer_app/core/result/result.dart';
import '../../domain/entities/home_section_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/remote/home_remote_data_source.dart';
import '../mappers/home_section_mapper.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeRemoteDataSource _dataSource;

  @override
  Future<Result<List<HomeSectionEntity>>> getHomeSections() {
    return safeCall(() async {
      final dtos = await _dataSource.getHomeSections();
      final entities = dtos
          .map((dto) => dto.toEntity())
          .where((section) => section.isActive)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      return entities;
    });
  }
}
