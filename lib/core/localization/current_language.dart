/// Tiny holder for the app's current language code, readable from places
/// that have no [BuildContext] — namely the Dio interceptor that sets the
/// `Accept-Language` header the backend uses to localize response
/// messages (every Auth endpoint declares this header, confirmed in
/// `docker/auth-swagger.json`).
///
/// Kept deliberately minimal (a static field, not a new state-management
/// layer) because there is exactly one writer ([FlowerApp.build], once
/// per rebuild — which happens on every locale change since `locale` is
/// passed to [MaterialApp]) and one reader (the network layer). Reaching
/// for a full notifier/stream here would be state management for its own
/// sake.
abstract final class CurrentLanguage {
  const CurrentLanguage._();

  static String code = 'en';
}
