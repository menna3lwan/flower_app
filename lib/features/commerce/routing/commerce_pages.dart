import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/features/commerce/ui/best_seller/pages/best_seller_view.dart';
import 'package:customer_app/features/commerce/ui/categories/pages/categories_view.dart';
import 'package:customer_app/features/commerce/ui/occasions/pages/occasions_view.dart';
import 'package:customer_app/features/commerce/ui/product_details/pages/product_details_view.dart';

import '../../../core/di/injector.dart';
import '../ui/product_details/manager/cubit/product_details_cubit.dart';
import '../ui/product_details/manager/cubit/product_details_intent.dart';

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
      page: () => BlocProvider<ProductDetailsCubit>(
          create: (context) => sl<ProductDetailsCubit>()..doIntent(GetProductByIdIntent('')),
          child: const ProductDetailsView()),
    ),
  ];
}
