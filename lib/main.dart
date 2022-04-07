import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''), // farsi
      ],
      theme: ThemeData(
        fontFamily: 'Dana',
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontFamily: 'Dana',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontFamily: 'Dana',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          headline3: TextStyle(
            color: Colors.red,
            fontFamily: 'Dana',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          headline4: TextStyle(
            color: Colors.green,
            fontFamily: 'Dana',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontFamily: 'Dana',
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
