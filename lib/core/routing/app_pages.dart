import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/view/splash_view.dart';
import '../di/injector.dart';
import 'app_routes.dart';

/// GetX route table mapping every wired [AppRoutes] name to a page; only Splash's own navigation target is wired so far.
abstract final class AppPages {
  const AppPages._();

  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => BlocProvider(
        create: (_) => sl<SplashCubit>(),
        child: const SplashView(),
      ),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => BlocProvider(
        create: (_) => sl<LoginCubit>(),
        child: const LoginView(),
      ),
    ),
  ];
}
