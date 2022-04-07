import 'package:flutter/material.dart';

class AdvertisementItem extends StatelessWidget {
  const AdvertisementItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 16,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [
            BoxShadow(blurRadius: 1, color: Colors.grey),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Ads',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
