import 'package:flutter/material.dart';

import 'app_localizations.dart';
import 'supported_locales.dart';

/// Bridges [AppLocalizations] into Flutter's standard `Localizations` mechanism — see `lib/app.dart`.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => SupportedLocales.all.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
