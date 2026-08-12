/// Centralized user-facing copy.
///
/// At this skeleton stage there is no localization pipeline, but routing
/// every string literal through here means adding `intl`/ARB files later
/// is a mechanical extraction instead of a codebase-wide hunt for text.
abstract final class AppStrings {
  const AppStrings._();

  static const String appName = 'Flowery';

  // Auth.
  static const String login = 'Login';
  static const String signUp = 'Sign up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm password';
  static const String rememberMe = 'Remember me';
  static const String forgetPassword = 'Forget password?';
  static const String continueAsGuest = 'Continue as guest';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String firstName = 'First name';
  static const String lastName = 'Last name';
  static const String phoneNumber = 'Phone number';
  static const String gender = 'Gender';
  static const String female = 'Female';
  static const String male = 'Male';
  static const String termsAgreement = 'Creating an account, you agree to our';
  static const String termsAndConditions = 'Terms & Conditions';

  // Home.
  static const String deliverTo = 'Deliver to';
  static const String categories = 'Categories';
  static const String bestSeller = 'Best seller';
  static const String occasion = 'Occasion';
  static const String viewAll = 'View All';
  static const String search = 'Search';
  static const String searchEmptyState = 'Search For Any Product You Want';

  // Product.
  static const String description = 'Description';
  static const String bouquetIncludes = 'Bouquet Includes';
  static const String addToCart = 'Add to cart';
  static const String inStock = 'In stock';

  // Cart & checkout.
  static const String cart = 'Cart';
  static const String subTotal = 'Sub Total';
  static const String deliveryFee = 'Delivery Fee';
  static const String total = 'Total';
  static const String checkout = 'Checkout';
  static const String address = 'Address';
  static const String payment = 'Payment';
  static const String trackOrder = 'Track order';
  static const String isGift = 'It is a gift';
  static const String deliverToLabel = 'Deliver to';
  static const String addNewAddress = 'Add new address';
  static const String next = 'Next';
  static const String paymentMethod = 'Payment method';
  static const String cashOnDelivery = 'Cash on delivery';
  static const String creditCard = 'Credit card';
  static const String placeOrder = 'Place order';
  static const String orderPlacedSuccess = 'Your order placed successfully!';
  static const String estimatedArrival = 'Estimated arrival';
  static const String showMap = 'Show map';

  // Orders / profile.
  static const String myOrders = 'My orders';
  static const String active = 'Active';
  static const String completed = 'Completed';
  static const String profile = 'Profile';
  static const String editProfile = 'Edit profile';
  static const String savedAddress = 'Saved address';
  static const String notifications = 'Notifications';
  static const String aboutUs = 'About us';
  static const String logout = 'Logout';
  static const String confirmLogout = 'Confirm logout!!';
  static const String cancel = 'Cancel';
  static const String update = 'Update';
  static const String save = 'Save';
}
