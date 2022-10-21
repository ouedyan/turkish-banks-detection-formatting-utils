import 'package:flutter/material.dart';

import '../../model/bank.dart';
import '../../model/card_system.dart';
import '../../utils.dart';

class CardFront extends StatelessWidget {
  final String? holderName;
  final int? cardNumber;
  final int? expirationMonth;
  final int? expirationYear;
  final CardSystem? cardSystem;
  final Bank? bank;

  final bool showBanner;

  const CardFront({
    Key? key,
    this.holderName,
    this.cardNumber,
    this.expirationMonth,
    this.expirationYear,
    this.cardSystem,
    this.bank,
    this.showBanner = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      clipBehavior: Clip.hardEdge,
      //Shadows
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(
              'assets/images/ig_card_front_background.png',
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffB8B8B8),
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (cardSystem?.image != null)
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 30,
                      maxWidth: 50,
                    ),
                    child: Image.asset(
                      cardSystem!.image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                if (bank?.image != null)
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 50,
                      maxWidth: 80,
                    ),
                    child: Image.asset(
                      bank!.image!,
                      fit: BoxFit.contain,
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(holderName ?? ""),
                  const SizedBox(height: 10),
                  Text(cardNumber != null ? formatCardNumber(cardNumber!) : ""),
                  const SizedBox(height: 10),
                  if (expirationMonth != null)
                    Text(
                        '${expirationMonth.toString().padLeft(2, '0')}/${expirationYear != null ? expirationYear! - 2000 : ""}'),
                ],
              ),
            ),
          ),
          Container(
            height: 20,
            decoration: showBanner && bank?.mainColor != null
                ? BoxDecoration(
                    gradient: LinearGradient(
                    colors: [
                      bank!.mainColor!,
                      HSLColor.fromColor(bank!.mainColor!)
                          .withLightness(0.8)
                          .toColor(),
                      bank!.mainColor!,
                    ],
                  ))
                : null,
          )
        ],
      ),
    );
  }
}
