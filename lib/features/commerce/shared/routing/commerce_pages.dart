import 'package:get/get.dart';

import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/features/commerce/best_seller/presentation/views/best_seller_view.dart';
import 'package:customer_app/features/commerce/categories/presentation/views/categories_view.dart';
import 'package:customer_app/features/commerce/occasions/presentation/views/occasions_view.dart';
import 'package:customer_app/features/commerce/product_details/presentation/views/product_details_view.dart';

/// Commerce's own slice of the app-wide GetPage table — route names stay centralized in [CustomerRoutes]; `main` stays in `customer_pages.dart` since it's a shared app-shell route, not Commerce-only.
abstract final class CommercePages {
  const CommercePages._();

  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: CustomerRoutes.categories,
      page: () => const CategoriesView(),
    ),
    GetPage(
      name: CustomerRoutes.bestSellerListing,
      page: () => const BestSellerView(),
    ),
    GetPage(
      name: CustomerRoutes.occasionListing,
      page: () => const OccasionsView(),
    ),
    GetPage(
      name: CustomerRoutes.productDetails,
      page: () => const ProductDetailsView(),
    ),
  ];
}
