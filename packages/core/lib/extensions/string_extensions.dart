/// String helpers shared across features (formatting, capitalization).
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isBlank => trim().isEmpty;
}

/// Currency formatting for the app's single supported currency (EGP), to
/// avoid re-implementing "EGP {amount}" string interpolation on every
/// screen that shows a price.
extension PriceFormatting on num {
  String get asEgp => 'EGP ${toStringAsFixed(0)}';
}
