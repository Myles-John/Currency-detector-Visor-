import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CurrencyDetectorApp());
  
}


class CurrencyDetectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
