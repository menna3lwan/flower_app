import 'package:flutter/services.dart';

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  const CapitalizeFirstLetterFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final firstChar = text[0];
    final capitalizedFirstChar = firstChar.toUpperCase();
    if (capitalizedFirstChar == firstChar) return newValue;

    return newValue.copyWith(
      text: capitalizedFirstChar + text.substring(1),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}
