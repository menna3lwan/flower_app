import '../../../models/home_section_dto.dart';
import '../home_remote_data_source.dart';

/// Dev-only stand-in for [HomeRemoteDataSource] — same contract, same [HomeSectionDto] shape as the
/// real backend, zero network calls. Lets Home be built/tested end-to-end before the Commerce API
/// exists; swapped in only for debug builds (see injectable_injector.config.dart), never in production.
/// Named `LocalMock...` rather than `Mock...` to avoid colliding with the Mockito test double of that
/// name already declared in test/support/mocks.dart.
class LocalMockHomeRemoteDataSource implements HomeRemoteDataSource {
  @override
  Future<List<HomeSectionDto>> getHomeSections() async {
    return const [
      // Inactive — must be filtered out by HomeRepositoryImpl before it ever reaches the UI.
      HomeSectionDto(
        id: 0,
        type: 'Categories',
        index: 0,
        isActive: false,
      ),
      // Unrecognized type — degrades to HomeSectionType.unknown and is dropped by LoadHomeUseCase,
      // proving an unsupported section never renders a gap or crashes.
      HomeSectionDto(
        id: 5,
        type: 'FlashSale',
        index: 5,
        isActive: true,
      ),
      // Figma-verified Home order: Categories precedes Best seller.
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
      // occasionId 101 has no matching entry in CatalogLocalDataSourceImpl's semantic-string occasion
      // IDs (e.g. 'occ-wedding') — a pre-existing, documented ID-scheme mismatch between Home's
      // backend-contract int IDs and Catalog's IDs. Left as-is (out of this task's scope), and doubles
      // as a real exercise of this section's Empty state.
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
