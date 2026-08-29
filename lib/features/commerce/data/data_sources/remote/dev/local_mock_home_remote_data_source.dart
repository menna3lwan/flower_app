import '../../../models/home_section_dto.dart';
import '../home_remote_data_source.dart';

/// Dev-only [HomeRemoteDataSource] with the real DTO shape and no network calls.
class LocalMockHomeRemoteDataSource implements HomeRemoteDataSource {
  @override
  Future<List<HomeSectionDto>> getHomeSections() async {
    return const [
      // Filtered out by HomeRepositoryImpl (isActive: false).
      HomeSectionDto(
        id: 0,
        type: 'Categories',
        index: 0,
        isActive: false,
      ),
      // Unknown type — LoadHomeUseCase drops it so Home never renders a gap.
      HomeSectionDto(
        id: 5,
        type: 'FlashSale',
        index: 5,
        isActive: true,
      ),
      HomeSectionDto(
        id: 10,
        type: 'Categories',
        index: 10,
        isActive: true,
      ),
      HomeSectionDto(
        id: 20,
        type: 'BestSeller',
        index: 20,
        isActive: true,
      ),
      HomeSectionDto(
        id: 30,
        type: 'Occasions',
        index: 30,
        isActive: true,
      ),
      // occasionId 101 has no catalog match, so this carousel hydrates empty.
      HomeSectionDto(
        id: 40,
        type: 'ProductsCarousel',
        index: 40,
        isActive: true,
        occasionId: 101,
      ),
    ];
  }
}
