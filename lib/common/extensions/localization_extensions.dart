import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

/// `context.l10n.login` shorthand for `AppLocalizations.of(context).login`, used by every widget for copy.
extension LocalizationExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
