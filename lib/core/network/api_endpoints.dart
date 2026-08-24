import 'dart:io' show Platform;

abstract final class ApiEndpoints {
  const ApiEndpoints._();

  static const String _baseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  // 10.0.2.2 is an Android-emulator-only loopback alias; iOS Simulator/macOS reach the Gateway via plain localhost.
  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;
    if (Platform.isAndroid) return 'http://10.0.2.2:9090';

    return 'http://localhost:9090';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth endpoints confirmed live against the real backend; the Gateway strips the "/Auth" prefix, so every path here must be called as "/Auth" + the Auth service's own route.
  static const String _authRoot = '/Auth/api/v1';

  static const String register = '$_authRoot/register';
  static const String verifyOtp = '$_authRoot/verify-otp';
  static const String userLogin = '$_authRoot/user/login';
  static const String resetPassword = '$_authRoot/reset-password';
  static const String refreshToken = '$_authRoot/refresh-token';
  static const String forgotPassword = '$_authRoot/forgot-password';
}
