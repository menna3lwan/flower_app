import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/route_placeholder_view.dart';

/// Route-reservation placeholder for `CustomerRoutes.occasionListing`.
///
/// Structure-only scaffolding (see Commerce module architecture
/// proposal) — replace with the real Occasions screen without changing
/// the route wiring.
class OccasionsView extends StatelessWidget {
  const OccasionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholderView(title: 'Occasions');
  }
}
