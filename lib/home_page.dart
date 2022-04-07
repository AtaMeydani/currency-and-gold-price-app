import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'advertisement_item.dart';
import 'currency_item.dart';
import 'currency_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Currency> currencyList = [];
  static const currencyItemPerAdd = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Text(
          'قیمت بروز سکه و ارز',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          Image.asset(
            'assets/images/icon.png',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Image.asset('assets/images/question_icon.png'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'نرخ ارز آزاد چیست؟',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            Text(
              ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(1000),
                ),
                color: Color.fromARGB(255, 130, 130, 130),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام آزاد ارز',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    'قیمت',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    'تغییر',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: listFutureBuilder(context),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 16,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        currencyList.clear();
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.refresh,
                      color: Colors.black,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'بروز رسانی',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 202, 193, 2550),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('آخرین بروز رسانی ${_getTime()}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: _getCurrencyList(context),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: currencyList.length,
                itemBuilder: (BuildContext context, int position) {
                  return CurrencyItem(
                      position: position, currencies: currencyList);
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % currencyItemPerAdd == 0) {
                    return const AdvertisementItem();
                  }
                  return const SizedBox.shrink();
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Future<http.Response> _getCurrencyList(BuildContext context) async {
    // http://sasansafari.com/flutter/api.php?access_key=flutter123456
    // Future<http.Response> futureData = http.get(Uri.parse(url));
    // return futureData.then((value) => _updateCurrencyList(value, context));

    const url =
        'http://sasansafari.com/flutter/api.php?access_key=flutter123456';
    var value = await http.get(Uri.parse(url));
    if(currencyList.isEmpty){
      _updateCurrencyList(value, context);
    }
    return value;

  }

  void _updateCurrencyList(http.Response value, BuildContext context) {
    if (value.statusCode == 200) {
      List currencies = [];

      try {
        currencies = convert.jsonDecode(value.body);
      } on FormatException {
        _showSnackBar(context, 'API Error.');
        developer.log('Invalid Response', name: 'API');
        return;
      }
      if (currencies.isNotEmpty) {
        currencyList = currencies
            .map((currency) => Currency(
                  id: currency['id'],
                  title: currency['title'],
                  price: _getFarsiNumber(currency['price']),
                  changes: _getFarsiNumber(currency['changes']),
                  status: currency['status'],
                ))
            .toList();

        Random random = Random();
        currencyList.add(Currency(
            id: currencyList.length.toString(),
            title: 'Testing',
            price: random.nextInt(100).toString(),
            changes: 'Testing',
            status: 'p'));
        _showSnackBar(context, 'بروز رسانی با موفقیت انجام شد.');
      } else {
        _showSnackBar(context, 'No information received.');
        developer.log('No information received.(empty currency list)',
            name: 'API');
      }
    } else {
      _showSnackBar(context, 'API server not found.');
      developer.log('Status Code: ${value.statusCode}', name: 'API');
    }
  }
}

String _getTime() {
  DateTime currentDate = DateTime.now();
  return DateFormat('kk:mm:ss').format(currentDate);
}

String _getFarsiNumber(String number) {
  const enToFa = {
    '0': '۰',
    '1': '۱',
    '2': '۲',
    '3': '۳',
    '4': '۴',
    '5': '۵',
    '6': '۶',
    '7': '۷',
    '8': '۸',
    '9': '۹'
  };

  String regex = enToFa.keys.join("|");
  return number.replaceAllMapped(
      RegExp(regex), (match) => enToFa[match.group(0)].toString());
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.headline2,
      ),
      backgroundColor: Colors.green,
    ),
  );
}
