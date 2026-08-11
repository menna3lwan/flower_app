/// Central registry of every route name in the app.
///
/// Screens never hardcode a path string when navigating — they reference
/// a constant from here via `Get.toNamed(AppRoutes.productDetails)`. The
/// GetX `GetPage` table that maps these names to widgets lives in
/// `app_pages.dart`, right next to this file.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';

  // Auth.
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';

  // Main shell (bottom nav: Home / Categories / Cart / Profile).
  static const String main = '/main';

  // Catalog.
  static const String categories = '/categories';
  static const String bestSellerListing = '/best-seller';
  static const String occasionListing = '/occasion';
  static const String productDetails = '/product-details';
  static const String search = '/search';

  // Cart & checkout.
  static const String cart = '/cart';
  static const String checkoutAddress = '/checkout/address';
  static const String checkoutPayment = '/checkout/payment';
  static const String orderSuccess = '/order-success';
  static const String trackOrder = '/track-order';

  // Address.
  static const String savedAddress = '/saved-address';
  static const String addAddress = '/add-address';

  // Orders.
  static const String orders = '/orders';

  // Profile.
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
}
