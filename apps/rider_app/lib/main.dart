import 'package:flutter/material.dart';

import 'di/rider_app_injector.dart';
import 'rider_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupRiderAppDependencies();
  runApp(const RiderApp());
}
