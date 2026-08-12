import 'package:flutter/material.dart';

/// Every locale the app ships UI copy for; add a `Locale` here plus its translations JSON to support a new one.
abstract final class SupportedLocales {
  const SupportedLocales._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> all = [english, arabic];

  static const Locale fallback = english;

  static bool isRtl(Locale locale) => locale.languageCode == arabic.languageCode;
}
