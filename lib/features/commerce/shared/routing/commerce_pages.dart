import 'package:get/get.dart';

import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/features/commerce/best_seller/presentation/views/best_seller_view.dart';
import 'package:customer_app/features/commerce/categories/presentation/views/categories_view.dart';
import 'package:customer_app/features/commerce/occasions/presentation/views/occasions_view.dart';
import 'package:customer_app/features/commerce/product_details/presentation/views/product_details_view.dart';

/// The Commerce module's own slice of the app-wide `GetPage` table.
///
/// Route *names* stay centralized in [CustomerRoutes] (single source of
/// truth — see the Commerce module architecture proposal), so this file
/// only maps those names to Commerce screens. Keeping the mapping here
/// means a `feat/commerce-*` branch can add or replace its own page
/// without touching `core/routing/customer_pages.dart` every time.
///
/// `CustomerRoutes.main` (the bottom-nav shell that will eventually host
/// the Home tab) is intentionally NOT listed here — it is an app-shell
/// route shared with non-Commerce tabs (Cart, Profile), not a
/// Commerce-only route, so it stays registered directly in
/// `customer_pages.dart`.
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
