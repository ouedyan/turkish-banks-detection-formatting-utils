import 'dart:math';

import 'package:flutter/material.dart';
import 'package:turkish_banks_detection_system/ui/widgets/card_front.dart';

import '../../model/bank.dart';
import '../../model/card_system.dart';
import '../../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? holderName;
  int? cardNumber;
  int? expirationMonth;
  int? expirationYear;
  int? cvc;
  CardSystem? currentDetectedCardSystem;
  Bank? currentDetectedBank;

  final cardNumberEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Turkish banks detection and formatting system',
        style: TextStyle(fontSize: 15),
      )),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            children: [
              // Card Preview
              CardFront(
                cardNumber: cardNumber,
                holderName: holderName,
                expirationMonth: expirationMonth,
                expirationYear: expirationYear,
                cardSystem: currentDetectedCardSystem,
                bank: currentDetectedBank,
              ),
              const SizedBox(height: 16),
              // Card Number
              TextField(
                controller: cardNumberEditController,
                onChanged: (value) => setState(() {
                  cardNumber =
                      int.tryParse(value.replaceAll(RegExp(r'[^0-9]+'), ''));
                }),
                inputFormatters: [
                  // Format using custom formatter
                  CardNumberFormatter(onCardSystemDetect: (cardSystem) {
                    if (currentDetectedCardSystem != cardSystem) {
                      setState(() {
                        currentDetectedCardSystem = cardSystem;
                      });
                    }
                  }, onBankDetect: (bank) {
                    if (currentDetectedBank != bank) {
                      currentDetectedBank = bank;
                    }
                  })
                ],
                decoration: InputDecoration(
                  labelText: "Card Number",
                  hintText: "**** **** **** ****",
                  suffixIcon: currentDetectedCardSystem?.image != null
                      ? Image.asset(
                          currentDetectedCardSystem!.image!,
                          fit: BoxFit.contain,
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    maxHeight: 30,
                    maxWidth: 50,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      // Generate a recognised turkish bank card number prefix
                      cardNumberEditController.text = formatCardNumber(
                          Bank.generateRandomRecognisedBankCardNumberPrefix(),
                          onCardSystemDetect: (cardSystem) {
                        currentDetectedCardSystem = cardSystem;
                      }, onBankDetect: (bank) {
                        currentDetectedBank = bank;
                      });
                      setState(() {
                        cardNumber = int.tryParse(cardNumberEditController.text
                            .replaceAll(RegExp(r'[^0-9]+'), ''));
                      });
                    },
                    child: const Text("Generate prefix")),
              ),
              const SizedBox(height: 16),
              // Card Holder
              TextField(
                onChanged: (value) => setState(() {
                  holderName = value;
                }),
                decoration: const InputDecoration(
                  labelText: "Card holder",
                  hintText: "Card holder's full name",
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expiration date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: (value) => setState(() {
                            expirationMonth = int.tryParse(
                                value.substring(0, min(2, value.length)));
                            int? newExpirationYear;
                            if (value.length >= 4) {
                              final twoDigitsYear =
                                  int.tryParse(value.substring(3));
                              if (twoDigitsYear != null) {
                                newExpirationYear = twoDigitsYear + 2000;
                              }
                            }
                            expirationYear = newExpirationYear;
                          }),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: false,
                          ),
                          inputFormatters: [cardExpirationFormatter],
                          decoration: const InputDecoration(
                            labelText: "Expiration Date",
                            hintText: "MM/YY",
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CVC
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: (value) => setState(() {
                            cvc = int.tryParse(value);
                          }),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: false,
                          ),
                          inputFormatters: [cvvFormatter],
                          decoration: const InputDecoration(
                            labelText: "Security Code",
                            hintText: "CVV/CVC",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
