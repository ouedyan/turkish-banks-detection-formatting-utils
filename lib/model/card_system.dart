class CardSystem {
  final String name;
  final String? image;
  final RegExp pattern;
  final Map<int, String> spacingPatterns;

  const CardSystem(this.name, this.image, this.pattern,
      {this.spacingPatterns = const {}});

  /// Returns the corresponding Card System from a given card number.
  ///
  /// Returns null if no match is found.
  static CardSystem? fromCardNumber(String cardNumber) {
    try {
      return list.singleWhere((element) =>
          element.pattern.hasMatch(cardNumber.replaceAll(r'[^0-9]+', '')));
    } on StateError {
      return null;
    }
  }

  // Recognised Card Systems list with their corresponding patterns and data
  static List<CardSystem> list = [
    CardSystem(
      mastercard,
      'assets/icons/ic_mastercard.png',
      RegExp(
          r'^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{0,12}$'),
      spacingPatterns: {16: 'XXXX XXXX XXXX XXXX'},
    ),
    CardSystem(
      visa,
      'assets/icons/ic_visa.png',
      RegExp(r'^4[0-9]{0,12}(?:[0-9]{0,3})?$'),
      spacingPatterns: {
        16: 'XXXX XXXX XXXX XXXX',
      },
    ),
    CardSystem(
      troy,
      'assets/icons/ic_troy.png',
      RegExp(r'^(65[0-9]{0,14})|(9792[0-9]{0,12})$'),
      spacingPatterns: {16: 'XXXX XXXX XXXX XXXX'},
    ),
    CardSystem(
      americanExpress,
      'assets/icons/ic_amex.png',
      RegExp(r'^(?:34|37)[0-9]{0,13}$'),
      spacingPatterns: {15: 'XXXX XXXXXX XXXXX'},
    ),
    CardSystem(
      cup,
      'assets/icons/ic_union_pay.png',
      RegExp(r'^(62[0-9]{0,17})$'),
      spacingPatterns: {
        16: 'XXXX XXXX XXXX XXXX',
        19: 'XXXXXX XXXXXXXXXXXXX',
      },
    ),
  ];

  // Recognised Card Systems
  static const String visa = 'Visa';
  static const String mastercard = 'Mastercard';
  static const String maestro = 'Maestro';
  static const String troy = 'Troy';
  static const String cup = 'China Union Pay';
  static const String jcb = 'JCB';
  static const String discover = 'Discover';
  static const String americanExpress = 'Amex';
  static const String mir = 'MIR';
}
