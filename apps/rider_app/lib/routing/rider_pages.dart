import 'package:get/get.dart';

/// GetX route table: maps every [RiderRoutes] name to the page it renders.
///
/// Empty by design — this pass builds the monorepo/architecture skeleton
/// only, no Rider feature screens are implemented yet. Each feature
/// appends its own `GetPage` entries here as it is built, following the
/// same pattern already established in `customer_app`'s `CustomerPages`.
abstract final class RiderPages {
  const RiderPages._();

  static final List<GetPage> pages = <GetPage>[];
}
