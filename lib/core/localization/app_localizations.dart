import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../constants/app_strings.dart';

/// Loads `assets/translations/<languageCode>.json` and exposes one analyzer-checked typed getter per key.
class AppLocalizations {
  AppLocalizations(this.locale, this._strings);

  final Locale locale;
  final Map<String, String> _strings;

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'AppLocalizations not found — is AppLocalizationsDelegate registered?');
    return localizations!;
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    final Map<String, dynamic> decoded = json.decode(jsonString) as Map<String, dynamic>;
    final strings = decoded.map((key, value) => MapEntry(key, value.toString()));
    return AppLocalizations(locale, strings);
  }

  /// Falls back to the raw key (never throws) so a missing translation is visibly wrong, not a crash.
  String translate(String key) => _strings[key] ?? key;

  /// "Enter {field}" in the active locale with [fieldLabel] substituted in, for `AppTextField`'s auto hint.
  String enterField(String fieldLabel) {
    return translate(AppStrings.enterFieldTemplate).replaceFirst('{field}', fieldLabel);
  }

  String get appName => translate(AppStrings.appName);

  String get login => translate(AppStrings.login);
  String get signUp => translate(AppStrings.signUp);
  String get email => translate(AppStrings.email);
  String get password => translate(AppStrings.password);
  String get confirmPassword => translate(AppStrings.confirmPassword);
  String get rememberMe => translate(AppStrings.rememberMe);
  String get forgetPassword => translate(AppStrings.forgetPassword);
  String get continueAsGuest => translate(AppStrings.continueAsGuest);
  String get dontHaveAccount => translate(AppStrings.dontHaveAccount);
  String get alreadyHaveAccount => translate(AppStrings.alreadyHaveAccount);
  String get firstName => translate(AppStrings.firstName);
  String get lastName => translate(AppStrings.lastName);
  String get phoneNumber => translate(AppStrings.phoneNumber);
  String get gender => translate(AppStrings.gender);
  String get female => translate(AppStrings.female);
  String get male => translate(AppStrings.male);
  String get termsAgreement => translate(AppStrings.termsAgreement);
  String get termsAndConditions => translate(AppStrings.termsAndConditions);
  String get forgotPasswordTitle => translate(AppStrings.forgotPasswordTitle);
  String get forgotPasswordSubtitle => translate(AppStrings.forgotPasswordSubtitle);
  String get confirm => translate(AppStrings.confirm);
  String get passwordSectionTitle => translate(AppStrings.passwordSectionTitle);
  String get verificationCodeTitle => translate(AppStrings.verificationCodeTitle);
  String get verificationCodeSubtitle => translate(AppStrings.verificationCodeSubtitle);
  String get resendCode => translate(AppStrings.resendCode);
  String get resetPasswordTitle => translate(AppStrings.resetPasswordTitle);
  String get currentPassword => translate(AppStrings.currentPassword);
  String get newPassword => translate(AppStrings.newPassword);

  String get deliverTo => translate(AppStrings.deliverTo);
  String get categories => translate(AppStrings.categories);
  String get bestSeller => translate(AppStrings.bestSeller);
  String get occasion => translate(AppStrings.occasion);
  String get viewAll => translate(AppStrings.viewAll);
  String get search => translate(AppStrings.search);
  String get searchEmptyState => translate(AppStrings.searchEmptyState);

  String get description => translate(AppStrings.description);
  String get bouquetIncludes => translate(AppStrings.bouquetIncludes);
  String get addToCart => translate(AppStrings.addToCart);
  String get inStock => translate(AppStrings.inStock);

  String get cart => translate(AppStrings.cart);
  String get subTotal => translate(AppStrings.subTotal);
  String get deliveryFee => translate(AppStrings.deliveryFee);
  String get total => translate(AppStrings.total);
  String get checkout => translate(AppStrings.checkout);
  String get address => translate(AppStrings.address);
  String get payment => translate(AppStrings.payment);
  String get trackOrder => translate(AppStrings.trackOrder);
  String get isGift => translate(AppStrings.isGift);
  String get addNewAddress => translate(AppStrings.addNewAddress);
  String get next => translate(AppStrings.next);
  String get paymentMethod => translate(AppStrings.paymentMethod);
  String get cashOnDelivery => translate(AppStrings.cashOnDelivery);
  String get creditCard => translate(AppStrings.creditCard);
  String get placeOrder => translate(AppStrings.placeOrder);
  String get orderPlacedSuccess => translate(AppStrings.orderPlacedSuccess);
  String get estimatedArrival => translate(AppStrings.estimatedArrival);
  String get showMap => translate(AppStrings.showMap);

  String get myOrders => translate(AppStrings.myOrders);
  String get active => translate(AppStrings.active);
  String get completed => translate(AppStrings.completed);
  String get profile => translate(AppStrings.profile);
  String get editProfile => translate(AppStrings.editProfile);
  String get savedAddress => translate(AppStrings.savedAddress);
  String get notifications => translate(AppStrings.notifications);
  String get aboutUs => translate(AppStrings.aboutUs);
  String get logout => translate(AppStrings.logout);
  String get confirmLogout => translate(AppStrings.confirmLogout);
  String get cancel => translate(AppStrings.cancel);
  String get update => translate(AppStrings.update);
  String get save => translate(AppStrings.save);
  String get retry => translate(AppStrings.retry);

  String get foundationPreviewTitle => translate(AppStrings.foundationPreviewTitle);
  String get foundationPreviewHeading => translate(AppStrings.foundationPreviewHeading);
  String get foundationPreviewBody => translate(AppStrings.foundationPreviewBody);
  String get foundationTypographySection => translate(AppStrings.foundationTypographySection);
  String get foundationButtonsSection => translate(AppStrings.foundationButtonsSection);
  String get foundationPrimaryButton => translate(AppStrings.foundationPrimaryButton);
  String get foundationSecondaryButton => translate(AppStrings.foundationSecondaryButton);
  String get foundationImageSection => translate(AppStrings.foundationImageSection);
  String get foundationEmptyStateSection => translate(AppStrings.foundationEmptyStateSection);
  String get foundationEmptyStateMessage => translate(AppStrings.foundationEmptyStateMessage);
  String get foundationDialogSection => translate(AppStrings.foundationDialogSection);
  String get foundationShowDialogButton => translate(AppStrings.foundationShowDialogButton);
  String get foundationDialogTitle => translate(AppStrings.foundationDialogTitle);
  String get foundationDialogMessage => translate(AppStrings.foundationDialogMessage);
  String get foundationLanguageSection => translate(AppStrings.foundationLanguageSection);
}
