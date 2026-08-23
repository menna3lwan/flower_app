import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/domain/usecases/continue_as_guest_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';

/// Builds a real [AuthCubit] wired through the real use cases onto
/// [repository] — the same object graph Injectable assembles in the app
/// (`core/di/injectable_injector.config.dart`), minus DI itself. Used by
/// every Auth widget test instead of each test file hand-rolling the
/// same six-use-case construction, now that [AuthCubit] depends on use
/// cases rather than taking a repository directly.
AuthCubit buildAuthCubit(AuthRepository repository) {
  return AuthCubit(
    LoginUseCase(repository),
    ContinueAsGuestUseCase(repository),
    SignUpUseCase(repository),
    ForgotPasswordUseCase(repository),
    VerifyOtpUseCase(repository),
    ResetPasswordUseCase(repository),
  );
}
