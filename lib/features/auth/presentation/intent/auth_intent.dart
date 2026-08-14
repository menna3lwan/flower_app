import '../../../../core/domain/entities/user_entity.dart';

/// Every action the Auth screens (Login, Sign Up, Forgot Password,
/// Verification, Reset Password) can dispatch to `AuthCubit`. A View
/// never calls a named Cubit method directly — it builds one of these
/// and hands it to `AuthCubit.onIntent()`, which is what makes this MVI
/// rather than plain Cubit-per-screen: the five screens are different
/// Views over one Intent → Cubit → State pipeline instead of five
/// independent ones.
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
    required this.phoneNumber,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
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
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}
