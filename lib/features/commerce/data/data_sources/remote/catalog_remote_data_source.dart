import '../../models/categories_response.dart';
import '../../models/occasions_response.dart';
import '../../models/product_details_response.dart';
import '../../models/products_response.dart';

abstract interface class CatalogRemoteDataSource {
  Future<CategoriesResponse> getCategories();
  Future<OccasionsResponse> getOccasions();
  Future<ProductsResponse> getAllProducts(int page, int pageSize,[String? filterId]);
  Future<ProductsResponse> getBestSeller(int page, int pageSize);
  Future<ProductDetailsResponse> getProductById(String id);

  Future<List<String>> occasionProductIds(String occasionId);
}