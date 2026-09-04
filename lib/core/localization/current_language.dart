/// Current language code, readable without a [BuildContext] (used by the Accept-Language interceptor); deliberately a static field, not a new state-management layer.
abstract final class CurrentLanguage {
  const CurrentLanguage._();

  static String code = 'en';
}
