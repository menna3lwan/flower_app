import 'package:core/di/injector.dart';

import './auth_injector.dart';
Future<void> setupCustomerAppDependencies() async {
  await setupCoreDependencies();
  await setupAuthDependencies();
}
