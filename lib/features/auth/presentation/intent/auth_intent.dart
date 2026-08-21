import '../../../../core/domain/entities/user_entity.dart';

sealed class AuthIntent {
  const AuthIntent();
}

final class LoginRequested extends AuthIntent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;
}

final class GuestLoginRequested extends AuthIntent {
  const GuestLoginRequested();
}

final class SignUpRequested extends AuthIntent {
  const SignUpRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final Gender gender;
}

final class ForgotPasswordRequested extends AuthIntent {
  const ForgotPasswordRequested(this.email);

  final String email;
}

final class VerifyCodeRequested extends AuthIntent {
  const VerifyCodeRequested({required this.email, required this.code});

  final String email;
  final String code;
}

final class ResetPasswordRequested extends AuthIntent {
  const ResetPasswordRequested({
    required this.resetToken,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  /// Issued by [VerifyCodeRequested]'s success response — see
  /// [AuthRepository.verifyCode].
  final String resetToken;
  final String newPassword;
  final String confirmNewPassword;
}
