import 'package:injectable/injectable.dart';
import '../../constants/enums/product_status.dart';
import '../../domain/entities/includes_entity.dart';
import '../../domain/entities/pagination_entity.dart';
import '../../domain/entities/product_details_entity.dart';
import '../../domain/entities/product_details_response_entity.dart';
import '../../domain/entities/product_item_entity.dart';
import '../../domain/entities/products_data_entity.dart';
import '../../domain/entities/products_response_entity.dart';

import '../models/product_details_data_dto.dart';
import '../models/product_details_response.dart';
import '../models/product_item_dto.dart';
import '../models/products_data_dto.dart';
import '../models/products_response.dart';
import '../../domain/entities/categories_response_entity.dart';
import '../../domain/entities/category_response_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../models/categories_response.dart';
import '../models/category_response.dart';
import '../models/category_dto.dart';
import '../../domain/entities/occasions_response_entity.dart';
import '../../domain/entities/occasion_entity.dart';
import '../models/occasions_response.dart';
import '../models/occasion_dto.dart';

@injectable
class CommerceMapper {
  const CommerceMapper();

  ProductDetailsEntity mapProductDetails(ProductDetailsDataDTO dto) {
    return ProductDetailsEntity(
      id: dto.id,
      name: dto.name,
      imageUrl: dto.imageUrls?.isNotEmpty == true ? dto.imageUrls!.first : '',
      currency: 'EGP',
      price: dto.discountedPrice,
      originalPrice: dto.originalPrice,
      discountPercentage: dto.discountPercentage,
      status: dto.isOutOfStock == true ? ProductStatus.outOfStock : ProductStatus.inStock,
      images: dto.imageUrls,
      description: dto.description,
      includes: dto.includes?.map((inc) => IncludesEntity(name: inc,quantity: dto.stockQuantity)).toList(),
      categoryId: null,
      occasionIds: null,
    );
  }

  ProductDetailsResponseEntity mapProductDetailsResponse(
      ProductDetailsResponse response) {
    return ProductDetailsResponseEntity(
      status: response.status ?? false,
      data: response.data != null ? mapProductDetails(response.data!) : null,
      errors: response.errors,
      code: response.code,
      message: response.message ?? '',
    );
  }

  //                      Products
  ProductsResponseEntity mapProductsResponseToEntity(
    ProductsResponse response,
  ) {
    return ProductsResponseEntity(
      status: response.status ?? false,
      data: response.data != null
          ? mapProductsDataToEntity(response.data!)
          : null,
      errors: response.errors,
      code: response.code,
      message: response.message ?? '',
    );
  }

  ProductsDataEntity mapProductsDataToEntity(ProductsDataDTO data) {
    return ProductsDataEntity(
      items: (data.items ?? []).map(mapProductItemToEntity).toList(),
      pagination: mapPaginationToEntity(data),
    );
  }

  ProductItemEntity mapProductItemToEntity(ProductItemDTO item) {
    return ProductItemEntity(
      id: item.id,
      name: item.name,
      imageUrl: item.imageUrl ?? '',
      currency: 'EGP',
      price: item.discountedPrice,
      originalPrice: item.originalPrice,
      discountPercentage: item.discountPercentage,
      status: item.isOutOfStock == true
          ? ProductStatus.outOfStock
          : ProductStatus.inStock,
    );
  }

  PaginationEntity mapPaginationToEntity(ProductsDataDTO data) {
    final page = data.pageNumber ?? 1;
    final pageSize = data.pageSize ?? 0;
    final totalCount = data.totalCount ?? 0;
    final totalPages = pageSize > 0 ? (totalCount / pageSize).ceil() : 0;
    return PaginationEntity(
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNextPage: data.hasNextPage ?? false,
      hasPreviousPage: page > 1,
    );
  }

  //                      Categories
  CategoriesResponseEntity mapCategoriesResponseToEntity(
    CategoriesResponse response,
  ) {
    return CategoriesResponseEntity(
      status: response.status ?? false,
      data: response.data?.map(mapCategoryToEntity).toList(),
      errors: response.errors,
      code: response.code,
      message: response.message ?? '',
    );
  }

  CategoryResponseEntity mapCategoryResponseToEntity(
    CategoryResponse response,
  ) {
    return CategoryResponseEntity(
      status: response.status ?? false,
      data: response.data != null ? mapCategoryToEntity(response.data!) : null,
      errors: response.errors,
      code: response.code,
      message: response.message ?? '',
    );
  }

  CategoryEntity mapCategoryToEntity(CategoryDTO dto) {
    return CategoryEntity(
      id: dto.id ?? '',
      name: dto.name ?? '',
      iconName: dto.iconUrl ?? '',
    );
  }

  //                      Occasions
  OccasionsResponseEntity mapOccasionsResponseToEntity(
    OccasionsResponse response,
  ) {
    return OccasionsResponseEntity(
      status: response.status ?? false,
      data: response.data?.map(mapOccasionToEntity).toList(),
      errors: response.errors,
      code: response.code,
      message: response.message ?? '',
    );
  }

  OccasionEntity mapOccasionToEntity(OccasionDTO dto) {
    return OccasionEntity(
      id: dto.id ?? '',
      name: dto.name ?? '',
      imageUrl: dto.imageUrl ?? '',
    );
  }
}
