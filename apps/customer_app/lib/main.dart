import 'package:flutter/material.dart';

import './app.dart';
import './di/customer_app_injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupCustomerAppDependencies();
  runApp(const FlowerApp());
}
