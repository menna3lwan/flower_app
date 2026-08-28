import 'package:customer_app/features/commerce/data/models/occasions_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../models/categories_response.dart';
import '../../models/category_dto.dart';
import '../../models/occasion_dto.dart';
import '../../models/product_details_data_dto.dart';
import '../../models/product_details_response.dart';
import '../../models/product_item_dto.dart';
import '../../models/products_data_dto.dart';
import '../../models/products_response.dart';
import 'catalog_remote_data_source.dart';

@LazySingleton(as: CatalogRemoteDataSource)
class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  static const _simulatedLatency = Duration(seconds: 3);


  @override
  Future<ProductDetailsResponse> getProductById(String id) async {
    await Future.delayed(_simulatedLatency);

    const response = ProductDetailsResponse(
      data: ProductDetailsDataDTO(
        id: '101',
        name: '15 Pink Rose Bouquet',
        imageUrls: [
          AppAssets.flower1,
          AppAssets.flower1,
          AppAssets.flower1,
          AppAssets.flower1,
        ],
        discountedPrice: 1500,
        originalPrice: 1600,
        discountPercentage: null,
        isOutOfStock: false,
        description:
        'Lorem ipsum dolor sit amet consectetur. Id sit morbi ornare morbi duis rhoncus orci massa.',
        includes: [
          'Pink roses',
          'White wrap',
        ],
        stockQuantity: 20,
      ),
      status: true,
      message: 'Success',
      code: 200,
      errors: [],
    );

    return response;
  }

  @override
  Future<ProductsResponse> getAllProducts(int page, int pageSize, [String? filterId]) async {
    await Future.delayed(_simulatedLatency);

    const totalItems = 50;
    final totalPages = (totalItems / pageSize).ceil();
    final isLastPage = page >= totalPages;

    // Simulate empty if page is beyond total pages
    final itemsCount = page > totalPages ? 0 : (isLastPage ? totalItems % pageSize : pageSize);
    final count = itemsCount == 0 && isLastPage && totalItems % pageSize == 0 ? pageSize : itemsCount;

    final items = List.generate(
      page > totalPages ? 0 : count,
          (index) {
        final id = ((page - 1) * pageSize) + index + 1;
        return ProductItemDTO(
          id: id.toString(),
          name: 'Bouquet $id',
          imageUrl: AppAssets.flower1,
          originalPrice: 400.0 + (id * 10),
          discountedPrice: 350.0 + (id * 10),
          discountPercentage: 12,
          isOutOfStock: id % 3 == 0,
        );
      },
    );

    final response = ProductsResponse(
      status: true,
      data: ProductsDataDTO(
        items: items,
        pageNumber: page,
        pageSize: pageSize,
        totalCount: totalItems,
        hasNextPage: page < totalPages,
      ),
      errors: const [],
      code: 200,
      message: 'Products retrieved successfully',
    );

    return response;
  }

  @override
  Future<ProductsResponse> getBestSeller(int page, int pageSize) async {
    await Future.delayed(_simulatedLatency);

    const totalItems = 50;
    final totalPages = (totalItems / pageSize).ceil();
    final isLastPage = page >= totalPages;

    // Simulate empty if page is beyond total pages
    final itemsCount = page > totalPages ? 0 : (isLastPage ? totalItems % pageSize : pageSize);
    final count = itemsCount == 0 && isLastPage && totalItems % pageSize == 0 ? pageSize : itemsCount;

    final items = List.generate(
      page > totalPages ? 0 : count,
          (index) {
        final id = ((page - 1) * pageSize) + index + 1;
        return ProductItemDTO(
          id: id.toString(),
          name: 'Bouquet $id',
          imageUrl: AppAssets.flower1,
          originalPrice: 400.0 + (id * 10),
          discountedPrice: 350.0 + (id * 10),
          discountPercentage: 12,
          isOutOfStock: id % 3 == 0,
        );
      },
    );

    final response = ProductsResponse(
      status: true,
      data: ProductsDataDTO(
        items: items,
        pageNumber: page,
        pageSize: pageSize,
        totalCount: totalItems,
        hasNextPage: page < totalPages,
      ),
      errors: const [],
      code: 200,
      message: 'Products retrieved successfully',
    );

    return response;
  }

  @override
  Future<CategoriesResponse> getCategories() async {
    await Future.delayed(_simulatedLatency);

    final response = CategoriesResponse(
      status: true,
      data: [
        CategoryDTO(
          id: '0b674089-eb6c-2ffb-a321-c9eb0a9bef25',
          name: 'Electronics',
          iconUrl: 'https://example.com/electronics.png',
        ),
        CategoryDTO(
          id: 'b857afb2-8535-c6a5-f093-72d52cad46a2',
          name: 'Groceries',
          iconUrl: 'https://example.com/groceries.png',
        ),
      ],
      errors: [],
      code: 200,
      message: 'Categories retrieved successfully',
    );

    return response;
  }


  @override
  Future<OccasionsResponse> getOccasions() async {
    await Future.delayed(_simulatedLatency);

    final response = OccasionsResponse(
      status: true,
      data: [
        OccasionDTO(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
          name: 'Wedding',
          imageUrl: 'https://example.com/electronics.png',
        ),

        OccasionDTO(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa7',
          name: 'Graduation',
          imageUrl: 'https://example.com/electronics.png',
        ),

        OccasionDTO(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa8',
          name: 'Birthday',
          imageUrl: 'https://example.com/electronics.png',
        ),

        OccasionDTO(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa9',
          name: 'Ramadan',
          imageUrl: 'https://example.com/electronics.png',
        ),

        OccasionDTO(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa1',
          name: 'Eid',
          imageUrl: 'https://example.com/electronics.png',
        ),

        OccasionDTO(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa2',
          name: 'Party',
          imageUrl: 'https://example.com/electronics.png',
        ),
      ],
      errors: [],
      code: 200,
      message: 'Categories retrieved successfully',
    );

    return response;
  }


  @override
  Future<List<String>> occasionProductIds(String occasionId) {
    // TODO: implement occasionProductIds
    throw UnimplementedError();
  }

}