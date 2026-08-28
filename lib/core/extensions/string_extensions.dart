/// String helpers shared across features (formatting, capitalization).
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isBlank => trim().isEmpty;
}

/// Currency formatting for the app's one supported currency (EGP).
extension PriceFormatting on num {
  String get asEgp => 'EGP ${toStringAsFixed(0)}';
}

/// Nullable variant so `price?.asEgp` call sites don't need extra null handling.
extension PriceFormattingNullable on num? {
  String get asEgp => this == null ? '—' : this!.asEgp;
}