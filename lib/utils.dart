import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'model/bank.dart';
import 'model/card_system.dart';

/// Formatter and validator for card number text inputs
class CardNumberFormatter extends TextInputFormatter {
  final void Function(CardSystem? cardSystem)? onCardSystemDetect;
  final void Function(Bank? bank)? onBankDetect;

  CardNumberFormatter({this.onCardSystemDetect, this.onBankDetect});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text.replaceAll(RegExp(r'[^0-9]+'), '');
    if (newText.length > 19) return oldValue;
    int? intText = int.tryParse(newText);
    String formattedText = intText != null
        ? formatCardNumber(
            intText,
            onCardSystemDetect: onCardSystemDetect,
            onBankDetect: onBankDetect,
          )
        : newText;
    return newValue.replaced(
      TextRange(
        start: 0,
        end: newValue.text.length,
      ),
      formattedText,
    );
  }
}

/// Formatter and validator for card expiration date text inputs
final cardExpirationFormatter =
    TextInputFormatter.withFunction((oldValue, newValue) {
  var newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
  var buffer = newText;
  if (newText.length > 4) return oldValue;
  if (newText.length >= 2) {
    final month = int.parse(newText.substring(0, 2));
    final finalMonth = max(1, min(12, month)).toString().padLeft(2, '0');
    buffer =
        finalMonth + (newText.length > 2 ? '/${newText.substring(2)}' : '');
  }
  if (newText.length >= 4) {
    final year = int.parse(newText.substring(2));
    final finalYear = max(DateTime.now().year - 2000,
            min(DateTime.now().year - 2000 + 20, year))
        .toString()
        .padLeft(2, '0');
    buffer = buffer.substring(0, 3) + finalYear;
  }
  final formatted = newValue.replaced(
      TextRange(
        start: 0,
        end: newValue.text.length,
      ),
      buffer);
  return formatted;
});

/// Formatter and validator for card CVV/CVC text inputs
final cvvFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
  var newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
  if (newText.length > 3) return oldValue;
  final formatted = newValue.replaced(
      TextRange(
        start: 0,
        end: newValue.text.length,
      ),
      newText);
  return formatted;
});

/// Formats a given card number according to the detected Card System's spacing pattern
///
/// You can provide [onCardSystemDetect] and [onBankDetect] callbacks to react on card system or bank detection
String formatCardNumber(int cardNumber,
    {void Function(CardSystem? cardSystem)? onCardSystemDetect,
    void Function(Bank? bank)? onBankDetect}) {
  if (cardNumber < 0 || cardNumber.toString().length > 19) {
    throw ArgumentError.value(
        cardNumber, 'cardNumber', 'Invalid card number argument');
  }
  var string = cardNumber.toString();
  final detectedCardSystem = CardSystem.fromCardNumber(string);
  String formattedText = string;
  onCardSystemDetect?.call(detectedCardSystem);
  if (detectedCardSystem != null) {
    if (onBankDetect != null) {
      Bank.fromCardNumber(string).then((detectedBank) {
        onBankDetect(detectedBank);
      });
    }
    // Format according to the length and the corresponding spacing pattern
    // (some card systems have different spacing patterns for different card number length)
    final spacingPatternsLengths =
        detectedCardSystem.spacingPatterns.keys.toList();
    spacingPatternsLengths.sort();
    String? spacingPattern;
    for (var length in spacingPatternsLengths) {
      if (string.length > length) {
        continue;
      } else {
        spacingPattern = detectedCardSystem.spacingPatterns[length]!;
        break;
      }
    }
    if (spacingPattern != null) {
      formattedText = formatStringWithSpacingPattern(string, spacingPattern);
    }
  }
  return formattedText;
}

/// Formats a given string according to an XXX based spacing pattern
///
/// Example:
/// 787546 with XX XXX X : 78 754 6
///
/// It is the core of the formatting system
String formatStringWithSpacingPattern(String string, spacingPattern) {
  String buffer = spacingPattern.toString();
  for (var char in string.characters) {
    if (buffer.contains('X')) {
      buffer = buffer.replaceFirst('X', char);
    } else {
      buffer += char;
    }
  }
  buffer = buffer.replaceAll('X', '');
  return buffer.trim();
}

/// Checks if a MM/YY formatted card expiration date is valid
bool isCardExpirationValid(String string) {
  final regExp = RegExp(r'^([0-9]{2})/([0-9]{2})$');
  if (regExp.hasMatch(string.trim())) {
    final match = regExp.firstMatch(string.trim())!;
    int month = int.parse(match.group(1)!);
    int year = int.parse(match.group(2)!) + 2000;
    return (month >= 1 && month <= 12) && (year >= DateTime.now().year);
  } else {
    return false;
  }
}

/// Checks if a Card CVV/CVC number is valid
bool isCvvValid(String string) {
  final regExp = RegExp(r'^[0-9]{3,4}$');
  return regExp.hasMatch(string.trim());
}
