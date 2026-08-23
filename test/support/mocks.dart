import 'package:mockito/mockito.dart';

import 'package:customer_app/features/auth/api/auth_api_service.dart';
import 'package:customer_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthApiService extends Mock implements AuthApiService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
