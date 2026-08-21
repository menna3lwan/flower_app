class ServerException implements Exception {
  const ServerException([this.message = 'Server error.']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error.']);

  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection.']);

  final String message;
}


class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;
}

/// Login was rejected because the email/password pair did not match.
class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

/// The submitted OTP was wrong or has expired.
class InvalidVerificationCodeException implements Exception {
  const InvalidVerificationCodeException();
}

/// No account exists for the email supplied to a password-reset request.
class EmailNotFoundException implements Exception {
  const EmailNotFoundException();
}

/// [AuthRepository.refreshSession] was called with no refresh token in
/// secure storage (e.g. never logged in, or already logged out).
class InvalidSessionException implements Exception {
  const InvalidSessionException();
}
