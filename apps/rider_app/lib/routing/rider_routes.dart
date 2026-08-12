/// Central registry of every route name in the Rider app.
///
/// Screens never hardcode a path string when navigating — they reference
/// a constant from here via `Get.toNamed(RiderRoutes.home)`. The GetX
/// `GetPage` table that maps these names to widgets lives in
/// `rider_pages.dart`, right next to this file.
///
/// Route names are derived from `Flower_App_Figma_Analysis.md` (Tracking
/// app flow) — no screen is wired to any of these yet, this is the route
/// table's shape only. Kept entirely separate from [CustomerRoutes] in
/// `customer_app`: the two apps never share a route table.
abstract final class RiderRoutes {
  const RiderRoutes._();

  static const String onboarding = '/onboarding';

  // Auth.
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verification-code';
  static const String resetPassword = '/reset-password';

  // Apply (become a rider).
  static const String apply = '/apply';
  static const String applySuccess = '/apply-success';

  // Delivery operations (main flow).
  static const String home = '/home';
  static const String orderDetails = '/order-details';
  static const String pickupLocation = '/pickup-location';
  static const String userLocation = '/user-location';
  static const String deliverySuccess = '/delivery-success';

  // Orders (history).
  static const String orders = '/orders';
  static const String orderSummary = '/order-summary';

  // Profile.
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
}
