import 'dart:io' show Platform;

abstract final class ApiEndpoints {
  const ApiEndpoints._();

  static const String _baseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  // 10.0.2.2 is an Android-emulator-only alias for the host loopback — it
  // means nothing on iOS/macOS, so this must stay Android-only. iOS
  // Simulator shares the host's network stack and reaches the Gateway via
  // plain `localhost`, same as running on macOS itself.
  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;
    if (Platform.isAndroid) return 'http://10.0.2.2:9090';

    return 'http://localhost:9090';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth endpoints — confirmed against the real backend running from
  // docker/docker-compose.yml (FlowersApp.Auth, Swagger read directly off
  // the container: GET /swagger/v1/swagger.json with
  // ASPNETCORE_ENVIRONMENT=Development). Verified end-to-end with live
  // curl calls through the Gateway (register -> login worked with the
  // exact same credentials, confirming the Gateway prefix-stripping
  // behaviour below is correct, not guessed).
  //
  // The Gateway (docker/docker-compose.yml's ReverseProxy config,
  // Auth_route) matches "/Auth/{**catch-all}" and strips the "/Auth"
  // prefix before forwarding to the Auth service, so every path below
  // must be called through the Gateway as "/Auth" + the Auth service's
  // own route (e.g. Auth service route "/api/v1/user/login" is reached
  // through the Gateway at "/Auth/api/v1/user/login").
  static const String _authRoot = '/Auth/api/v1';

  static const String register = '$_authRoot/register';
  static const String verifyOtp = '$_authRoot/verify-otp';
  static const String userLogin = '$_authRoot/user/login';
  static const String resetPassword = '$_authRoot/reset-password';
  static const String refreshToken = '$_authRoot/refresh-token';
  static const String forgotPassword = '$_authRoot/forgot-password';
}
