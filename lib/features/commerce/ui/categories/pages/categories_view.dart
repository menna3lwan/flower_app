import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/route_placeholder_view.dart';
import 'package:customer_app/core/localization/app_strings.dart';

/// Route-reservation placeholder for `CustomerRoutes.categories`.
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholderView(title: AppStrings.categories);
  }
}
