/// Translation key names (not display text) shared by `AppLocalizations` and both `assets/translations/*.json` files.
abstract final class AppStrings {
  const AppStrings._();

  static const String appName = 'appName';

  // Auth.
  static const String login = 'login';
  static const String signUp = 'signUp';
  static const String email = 'email';
  static const String password = 'password';
  static const String confirmPassword = 'confirmPassword';
  static const String rememberMe = 'rememberMe';
  static const String forgetPassword = 'forgetPassword';
  static const String continueAsGuest = 'continueAsGuest';
  static const String dontHaveAccount = 'dontHaveAccount';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String phoneNumber = 'phoneNumber';
  static const String gender = 'gender';
  static const String female = 'female';
  static const String male = 'male';
  static const String termsAgreement = 'termsAgreement';
  static const String termsAndConditions = 'termsAndConditions';
  static const String forgotPasswordTitle = 'forgotPasswordTitle';
  static const String forgotPasswordSubtitle = 'forgotPasswordSubtitle';
  static const String confirm = 'confirm';
  static const String passwordSectionTitle = 'passwordSectionTitle';
  static const String verificationCodeTitle = 'verificationCodeTitle';
  static const String verificationCodeSubtitle = 'verificationCodeSubtitle';
  static const String resendCode = 'resendCode';
  static const String resetPasswordTitle = 'resetPasswordTitle';
  static const String currentPassword = 'currentPassword';
  static const String newPassword = 'newPassword';

  /// Template for `AppTextField`'s auto-generated hint text; contains a literal `{field}` token.
  static const String enterFieldTemplate = 'enterFieldTemplate';

  // Home.
  static const String deliverTo = 'deliverTo';
  static const String categories = 'categories';
  static const String bestSeller = 'bestSeller';
  static const String occasion = 'occasion';
  static const String viewAll = 'viewAll';
  static const String search = 'search';
  static const String searchEmptyState = 'searchEmptyState';

  // Product.
  static const String description = 'description';
  static const String bouquetIncludes = 'bouquetIncludes';
  static const String addToCart = 'addToCart';
  static const String inStock = 'inStock';

  // Cart & checkout.
  static const String cart = 'cart';
  static const String subTotal = 'subTotal';
  static const String deliveryFee = 'deliveryFee';
  static const String total = 'total';
  static const String checkout = 'checkout';
  static const String address = 'address';
  static const String payment = 'payment';
  static const String trackOrder = 'trackOrder';
  static const String isGift = 'isGift';
  static const String addNewAddress = 'addNewAddress';
  static const String next = 'next';
  static const String paymentMethod = 'paymentMethod';
  static const String cashOnDelivery = 'cashOnDelivery';
  static const String creditCard = 'creditCard';
  static const String placeOrder = 'placeOrder';
  static const String orderPlacedSuccess = 'orderPlacedSuccess';
  static const String estimatedArrival = 'estimatedArrival';
  static const String showMap = 'showMap';

  // Orders / profile.
  static const String myOrders = 'myOrders';
  static const String active = 'active';
  static const String completed = 'completed';
  static const String profile = 'profile';
  static const String editProfile = 'editProfile';
  static const String savedAddress = 'savedAddress';
  static const String notifications = 'notifications';
  static const String aboutUs = 'aboutUs';
  static const String logout = 'logout';
  static const String confirmLogout = 'confirmLogout';
  static const String cancel = 'cancel';
  static const String update = 'update';
  static const String save = 'save';
  static const String retry = 'retry';

  // Foundation preview (temporary scaffold screen — see `lib/foundation_preview_screen.dart`).
  static const String foundationPreviewTitle = 'foundationPreviewTitle';
  static const String foundationPreviewHeading = 'foundationPreviewHeading';
  static const String foundationPreviewBody = 'foundationPreviewBody';
  static const String foundationTypographySection = 'foundationTypographySection';
  static const String foundationButtonsSection = 'foundationButtonsSection';
  static const String foundationPrimaryButton = 'foundationPrimaryButton';
  static const String foundationSecondaryButton = 'foundationSecondaryButton';
  static const String foundationImageSection = 'foundationImageSection';
  static const String foundationEmptyStateSection = 'foundationEmptyStateSection';
  static const String foundationEmptyStateMessage = 'foundationEmptyStateMessage';
  static const String foundationDialogSection = 'foundationDialogSection';
  static const String foundationShowDialogButton = 'foundationShowDialogButton';
  static const String foundationDialogTitle = 'foundationDialogTitle';
  static const String foundationDialogMessage = 'foundationDialogMessage';
  static const String foundationLanguageSection = 'foundationLanguageSection';
}
