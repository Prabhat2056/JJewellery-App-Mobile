import 'package:flutter/services.dart';

class SingleDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.split(".").length > 2 ||
        newValue.text.contains("-") ||
        newValue.text.contains("+") ||
        newValue.text.contains("/") ||
        newValue.text.contains("#") ||
        newValue.text.contains("(") ||
        newValue.text.contains(")")) {
      return oldValue.copyWith(
        text: oldValue.text,
        selection: TextSelection.collapsed(offset: oldValue.text.length),
      );
    }
    return newValue;
  }
}
