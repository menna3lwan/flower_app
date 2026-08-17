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

  /// Placeholder for a field the caller didn't give an explicit hint for.
  static String enterField(String field) =>
      'enterFieldTemplate'.tr(namedArgs: {'field': field});

  // Field validation — one message per rule, so "missing" and "malformed"
  // never collapse into the same text.
  static String get emailRequired => 'emailRequired'.tr();
  static String get invalidEmail => 'invalidEmail'.tr();
  static String get passwordRequired => 'passwordRequired'.tr();
  static String passwordTooShort(int minLength) =>
      'passwordTooShort'.tr(namedArgs: {'count': '$minLength'});
  static String get firstNameRequired => 'firstNameRequired'.tr();
  static String get lastNameRequired => 'lastNameRequired'.tr();
  static String get phoneRequired => 'phoneRequired'.tr();
  static String get verificationCodeRequired => 'verificationCodeRequired'.tr();

  static String get fieldRequired => 'fieldRequired'.tr();
  static String get invalidPhoneNumber => 'invalidPhoneNumber'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get passwordsDoNotMatch => 'passwordsDoNotMatch'.tr();
  static String get verificationCodeIncomplete =>
      'verificationCodeIncomplete'.tr();
  static String get verificationCodeResent => 'verificationCodeResent'.tr();

  static String get invalidCredentials => 'invalidCredentials'.tr();
  static String get invalidVerificationCode => 'invalidVerificationCode'.tr();
  static String get emailNotFound => 'emailNotFound'.tr();
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get somethingWentWrong => 'somethingWentWrong'.tr();

  // Success feedback.
  static String get accountCreatedSuccess => 'accountCreatedSuccess'.tr();
  static String get passwordResetSuccess => 'passwordResetSuccess'.tr();

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

  static String get resendCodePrefix => 'resendCodePrefix'.tr();
  static String get resendCodeAction => 'resendCodeAction'.tr();
  static String get resetPasswordTitle => 'resetPasswordTitle'.tr();
  static String get resetPasswordSubtitle => 'resetPasswordSubtitle'.tr();
  static String get currentPassword => 'currentPassword'.tr();
  static String get newPassword => 'newPassword'.tr();

  // Password visibility toggle + live requirements checklist — shared by
  // every password field via AppTextField/PasswordRulesChecklist, never
  // hardcoded per screen.
  static String get showPassword => 'showPassword'.tr();
  static String get hidePassword => 'hidePassword'.tr();
  static String get passwordRequirementsTitle =>
      'passwordRequirementsTitle'.tr();
  static String get passwordRuleMinLength => 'passwordRuleMinLength'.tr();
  static String get passwordRuleUppercase => 'passwordRuleUppercase'.tr();
  static String get passwordRuleNumber => 'passwordRuleNumber'.tr();
  static String get passwordRequirementsNotMet =>
      'passwordRequirementsNotMet'.tr();

  static String get signUpFirstNameHint => 'signUpFirstNameHint'.tr();
  static String get signUpLastNameHint => 'signUpLastNameHint'.tr();
  static String get signUpEmailHint => 'signUpEmailHint'.tr();
  static String get signUpPasswordHint => 'signUpPasswordHint'.tr();
  static String get signUpConfirmPasswordHint =>
      'signUpConfirmPasswordHint'.tr();
  static String get signUpPhoneNumberHint => 'signUpPhoneNumberHint'.tr();

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

  static String? get invalidPassword => null;
}
