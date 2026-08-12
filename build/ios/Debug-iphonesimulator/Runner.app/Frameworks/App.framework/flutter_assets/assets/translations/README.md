# assets/translations

Reserved for ARB/JSON translation files once localization is
introduced. Every user-facing string in the app currently flows through
`lib/core/constants/app_strings.dart` as a hardcoded (English) constant
— see that file's doc comment — specifically so extracting this folder
later is mechanical: move each `AppStrings` value into an ARB entry,
wire up `flutter_localizations` + `intl`, and repoint `AppStrings`
getters at the generated localization class.
