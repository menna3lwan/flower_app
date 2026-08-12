import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:core/di/injector.dart';
import '../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../features/auth/presentation/cubit/login/login_cubit.dart';
import '../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import '../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import '../features/auth/presentation/views/forgot_password_view.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/otp_verification_view.dart';
import '../features/auth/presentation/views/reset_password_view.dart';
import '../features/auth/presentation/views/sign_up_view.dart';
import './customer_routes.dart';

abstract final class CustomerPages {
  const CustomerPages._();

  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: CustomerRoutes.login,
      page: () => BlocProvider(
        create: (_) => sl<LoginCubit>(),
        child: const LoginView(),
      ),
    ),
    GetPage(
      name: CustomerRoutes.signUp,
      page: () => BlocProvider(
        create: (_) => sl<SignUpCubit>(),
        child: const SignUpView(),
      ),
    ),
    GetPage(
      name: CustomerRoutes.forgotPassword,
      page: () => BlocProvider(
        create: (_) => sl<ForgotPasswordCubit>(),
        child: const ForgotPasswordView(),
      ),
    ),
    GetPage(
      name: CustomerRoutes.otpVerification,
      page: () => const OtpVerificationView(),
    ),
    GetPage(
      name: CustomerRoutes.resetPassword,
      page: () => BlocProvider(
        create: (_) => sl<ResetPasswordCubit>(),
        child: const ResetPasswordView(),
      ),
    ),
  ];
}
