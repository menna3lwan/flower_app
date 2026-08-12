/// String helpers shared across features (formatting, capitalization).
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isBlank => trim().isEmpty;
}

/// Currency formatting for the app's single supported currency (EGP).
extension PriceFormatting on num {
  String get asEgp => 'EGP ${toStringAsFixed(0)}';
}
