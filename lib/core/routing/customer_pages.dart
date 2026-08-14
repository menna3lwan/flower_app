import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/di/injector.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:customer_app/features/auth/presentation/views/login_view.dart';
import 'package:customer_app/features/auth/presentation/views/otp_verification_view.dart';
import 'package:customer_app/features/auth/presentation/views/reset_password_view.dart';
import 'package:customer_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:customer_app/features/splash/presentation/views/splash_view.dart';
import './customer_routes.dart';

abstract final class CustomerPages {
  const CustomerPages._();

  static final List<GetPage> pages = <GetPage>[
    // SplashView already existed fully built but was never registered
    // here, so the app skipped straight to Login — wiring it in is a
    // routing fix, not new functionality (no Cubit/business logic
    // touched, the screen and its own redirect-to-Login timer already
    // existed as-is).
    GetPage(
      name: CustomerRoutes.splash,
      page: () => const SplashView(),
    ),
    // Login, Sign Up, and Forgot Password each get their own AuthCubit
    // instance (registerFactory — a fresh one per BlocProvider) rather
    // than sharing one: form/error state shouldn't leak from one screen
    // into the next, only the Cubit *class* is shared, not an instance.
    GetPage(
      name: CustomerRoutes.login,
      page: () => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const LoginView(),
      ),
    ),
    GetPage(
      name: CustomerRoutes.signUp,
      page: () => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const SignUpView(),
      ),
    ),
    GetPage(
      name: CustomerRoutes.forgotPassword,
      page: () => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const ForgotPasswordView(),
      ),
    ),
    GetPage(
      name: CustomerRoutes.otpVerification,
      page: () => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const OtpVerificationView(),
      ),
    ),
    // Reset Password isn't reached from the Forgot Password/Verification
    // chain (see OtpVerificationView's doc comment) — Figma only shows it
    // as a Profile > change-password screen. It's still registered here
    // (and still driven by AuthCubit, per the single-Cubit rule) so the
    // route exists once Profile links to it.
    GetPage(
      name: CustomerRoutes.resetPassword,
      page: () => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const ResetPasswordView(),
      ),
    ),
  ];
}
