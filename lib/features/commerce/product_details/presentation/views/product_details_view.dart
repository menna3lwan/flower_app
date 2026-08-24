import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/route_placeholder_view.dart';

/// Route-reservation placeholder for `CustomerRoutes.productDetails`.
///
/// Structure-only scaffolding (see Commerce module architecture
/// proposal) — replace with the real Product Details screen without
/// changing the route wiring.
class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderView(title: 'Product Details');
  }
}
