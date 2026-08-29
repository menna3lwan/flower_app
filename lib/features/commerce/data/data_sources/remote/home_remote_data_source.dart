import '../../models/home_section_dto.dart';

/// Contract for Home's own remote data source; [HomeRemoteDataSourceImpl] is the only implementation — there is no local/dummy fallback for the section layout itself.
abstract interface class HomeRemoteDataSource {
  Future<List<HomeSectionDto>> getHomeSections();
}
