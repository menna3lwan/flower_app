import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/domain/usecases/continue_as_guest_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:customer_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';

/// Builds a real [AuthCubit] wired through the real use cases — the same object graph Injectable assembles, minus DI itself.
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
