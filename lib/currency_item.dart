import 'package:currency_and_gold_price_app/currency_model.dart';
import 'package:flutter/material.dart';

class CurrencyItem extends StatelessWidget {
  final int position;
  final List<Currency> currencies;

  const CurrencyItem({required this.position, required this.currencies, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [
            BoxShadow(blurRadius: 1, color: Colors.grey),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              currencies[position].title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              currencies[position].price,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              currencies[position].changes,
              style: currencies[position].status == 'n'
                  ? Theme.of(context).textTheme.headline3
                  : Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }

}
