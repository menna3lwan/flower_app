import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/route_placeholder_view.dart';

/// Route-reservation placeholder for `CustomerRoutes.bestSellerListing`.
///
/// Structure-only scaffolding (see Commerce module architecture
/// proposal) — replace with the real Best Sellers screen without
/// changing the route wiring.
class BestSellerView extends StatelessWidget {
  const BestSellerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderView(title: 'Best Sellers');
  }
}
