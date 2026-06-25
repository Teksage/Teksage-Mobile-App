import 'package:flutter/services.dart';

class MobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Ensure digits do not exceed 10 (excluding country code)
    if (digits.startsWith('91')) {
      digits = digits.substring(2); // Remove extra '91' if user types it
    }

    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    // Format the text properly
    String formattedText = '+91';
    if (digits.isNotEmpty) {
      formattedText += ' ';
      if (digits.length > 5) {
        formattedText += '${digits.substring(0, 5)} ${digits.substring(5)}';
      } else {
        formattedText += digits;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text.replaceAll(' ', '').toLowerCase();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

