import 'package:injectable/injectable.dart';

import 'package:customer_app/core/error/exceptions.dart';
import '../../api/home_api_service.dart';
import '../../models/home_section_dto.dart';
import '../../models/home_sections_response_dto.dart';
import 'home_remote_data_source.dart';

/// Talks to the real Home backend via Retrofit, per `flowery-app-api (1).yaml`; only ever throws — never returns a Result itself (that's the repository's job).
@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._apiService);

  final HomeApiService _apiService;

  @override
  Future<List<HomeSectionDto>> getHomeSections() async {
    final json = await _apiService.getHomeSections();
    final response = HomeSectionsResponseDto.fromJson(json);
    if (!response.isSuccess) {
      throw const ServerException('Failed to load home sections.');
    }
    return response.sections;
  }
}
