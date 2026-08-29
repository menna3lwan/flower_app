import 'package:customer_app/features/commerce/data/models/occasions_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../models/categories_response.dart';
import '../../models/product_details_data_dto.dart';
import '../../models/product_details_response.dart';
import '../../models/products_response.dart';
import 'catalog_remote_data_source.dart';

@Injectable(as: CatalogRemoteDataSource)
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
  Future<ProductsResponse> getAllProducts(int page, int pageSize, [String? filterId]) {
    // TODO: implement getAllProducts
    throw UnimplementedError();
  }

  @override
  Future<ProductsResponse> getBestSeller(int page, int pageSize) {
    // TODO: implement getBestSeller
    throw UnimplementedError();
  }

  @override
  Future<CategoriesResponse> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<OccasionsResponse> getOccasions() {
    // TODO: implement getOccasions
    throw UnimplementedError();
  }

  @override
  Future<List<String>> occasionProductIds(String occasionId) {
    // TODO: implement occasionProductIds
    throw UnimplementedError();
  }

}