import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';

/// Maps a domain [Failure] to localized Home copy.
extension HomeFailureMessage on Failure {
  String get homeMessage => switch (this) {
        NetworkFailure() => AppStrings.noInternetConnection,
        _ => AppStrings.somethingWentWrong,
      };
}
