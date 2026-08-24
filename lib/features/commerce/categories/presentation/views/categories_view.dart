import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/route_placeholder_view.dart';

/// Route-reservation placeholder for `CustomerRoutes.categories`.
///
/// Structure-only scaffolding (see Commerce module architecture
/// proposal) — replace with the real Categories screen without
/// changing the route wiring.
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderView(title: 'Categories');
  }
}
