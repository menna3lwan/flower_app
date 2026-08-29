import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';

/// Maps a domain [Failure] to a curated, localized, non-technical message for the Home screen — mirrors `auth_failure_message.dart`'s pattern.
extension HomeFailureMessage on Failure {
  String get homeMessage => switch (this) {
        NetworkFailure() => AppStrings.noInternetConnection,
        _ => AppStrings.somethingWentWrong,
      };
}
