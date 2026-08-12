import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../storage/local_storage_service.dart';
import 'supported_locales.dart';

const String _localeStorageKey = 'app_locale';

/// Owns the active [Locale]: persists the user's choice and applies it app-wide via `Get.updateLocale`.
class LocaleController {
  LocaleController(this._localStorageService);

  final LocalStorageService _localStorageService;

  Future<Locale> loadPersistedLocale() async {
    final code = await _localStorageService.getString(_localeStorageKey);
    final match = SupportedLocales.all.where((locale) => locale.languageCode == code);
    return match.isNotEmpty ? match.first : SupportedLocales.fallback;
  }

  Future<void> changeLocale(Locale locale) async {
    await _localStorageService.setString(_localeStorageKey, locale.languageCode);
    Get.updateLocale(locale);
  }
}
