import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';

extension AuthFailureMessage on Failure {
  String get localizedMessage => switch (this) {
        InvalidCredentialsFailure() => AppStrings.invalidCredentials,
        InvalidVerificationCodeFailure() => AppStrings.invalidVerificationCode,
        NotFoundFailure() => AppStrings.emailNotFound,
        NetworkFailure() => AppStrings.noInternetConnection,
        AuthFailure() ||
        ServerFailure() ||
        ValidationFailure() ||
        UnexpectedFailure() =>
          AppStrings.somethingWentWrong,
      };
}
