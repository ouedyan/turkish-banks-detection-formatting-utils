import 'bank.dart';
import 'card_system.dart';

class Card {
  final String holderName;
  final int cardNumber;
  final int expirationMonth;
  final int expirationYear;
  final CardSystem? cardSystem;
  final Bank? bank;

  const Card(
      {required this.holderName,
      required this.cardNumber,
      required this.expirationMonth,
      required this.expirationYear,
      this.cardSystem,
      this.bank})
      : assert(expirationMonth >= 1 && expirationMonth <= 12),
        assert(expirationYear > 0);
}
