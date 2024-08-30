import 'package:flutter/material.dart';
import '../widgets/currency_result.dart';

class ResultScreen extends StatelessWidget {
  final String currency;

  ResultScreen({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detected Currency'),
      ),
      body: CurrencyResult(currency: currency),
    );
  }
}
