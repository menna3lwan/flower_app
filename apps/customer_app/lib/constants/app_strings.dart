import 'package:easy_localization/easy_localization.dart';

abstract final class AppStrings {
  const AppStrings._();

  static String get appName => 'appName'.tr();

  // Auth.
  static String get login => 'login'.tr();
  static String get signUp => 'signUp'.tr();
  static String get email => 'email'.tr();
  static String get password => 'password'.tr();
  static String get confirmPassword => 'confirmPassword'.tr();
  static String get rememberMe => 'rememberMe'.tr();
  static String get forgetPassword => 'forgetPassword'.tr();
  static String get continueAsGuest => 'continueAsGuest'.tr();
  static String get dontHaveAccount => 'dontHaveAccount'.tr();

  static String get enterYourEmail => 'enterYourEmail'.tr();
  static String get enterYourPassword => 'enterYourPassword'.tr();
  static String get invalidEmail => 'invalidEmail'.tr();
  static String get invalidPassword => 'invalidPassword'.tr();
  static String get alreadyHaveAccount => 'alreadyHaveAccount'.tr();
  static String get firstName => 'firstName'.tr();
  static String get lastName => 'lastName'.tr();
  static String get phoneNumber => 'phoneNumber'.tr();
  static String get gender => 'gender'.tr();
  static String get female => 'female'.tr();
  static String get male => 'male'.tr();
  static String get termsAgreement => 'termsAgreement'.tr();
  static String get termsAndConditions => 'termsAndConditions'.tr();
  static String get forgotPasswordTitle => 'forgotPasswordTitle'.tr();
  static String get forgotPasswordSubtitle => 'forgotPasswordSubtitle'.tr();
  static String get confirm => 'confirm'.tr();
  static String get passwordSectionTitle => 'passwordSectionTitle'.tr();
  static String get verificationCodeTitle => 'verificationCodeTitle'.tr();
  static String get verificationCodeSubtitle => 'verificationCodeSubtitle'.tr();
  static String get resendCode => 'resendCode'.tr();
  static String get resetPasswordTitle => 'resetPasswordTitle'.tr();
  static String get currentPassword => 'currentPassword'.tr();
  static String get newPassword => 'newPassword'.tr();

  // Home.
  static String get deliverTo => 'deliverTo'.tr();
  static String get categories => 'categories'.tr();
  static String get bestSeller => 'bestSeller'.tr();
  static String get occasion => 'occasion'.tr();
  static String get viewAll => 'viewAll'.tr();
  static String get search => 'search'.tr();
  static String get searchEmptyState => 'searchEmptyState'.tr();

  // Product.
  static String get description => 'description'.tr();
  static String get bouquetIncludes => 'bouquetIncludes'.tr();
  static String get addToCart => 'addToCart'.tr();
  static String get inStock => 'inStock'.tr();

  // Cart & checkout.
  static String get cart => 'cart'.tr();
  static String get subTotal => 'subTotal'.tr();
  static String get deliveryFee => 'deliveryFee'.tr();
  static String get total => 'total'.tr();
  static String get checkout => 'checkout'.tr();
  static String get address => 'address'.tr();
  static String get payment => 'payment'.tr();
  static String get trackOrder => 'trackOrder'.tr();
  static String get isGift => 'isGift'.tr();

  static String get deliverToLabel => 'deliverTo'.tr();
  static String get addNewAddress => 'addNewAddress'.tr();
  static String get next => 'next'.tr();
  static String get paymentMethod => 'paymentMethod'.tr();
  static String get cashOnDelivery => 'cashOnDelivery'.tr();
  static String get creditCard => 'creditCard'.tr();
  static String get placeOrder => 'placeOrder'.tr();
  static String get orderPlacedSuccess => 'orderPlacedSuccess'.tr();
  static String get estimatedArrival => 'estimatedArrival'.tr();
  static String get showMap => 'showMap'.tr();

  // Orders / profile.
  static String get myOrders => 'myOrders'.tr();
  static String get active => 'active'.tr();
  static String get completed => 'completed'.tr();
  static String get profile => 'profile'.tr();
  static String get editProfile => 'editProfile'.tr();
  static String get savedAddress => 'savedAddress'.tr();
  static String get notifications => 'notifications'.tr();
  static String get aboutUs => 'aboutUs'.tr();
  static String get logout => 'logout'.tr();
  static String get confirmLogout => 'confirmLogout'.tr();
  static String get cancel => 'cancel'.tr();
  static String get update => 'update'.tr();
  static String get save => 'save'.tr();
}
