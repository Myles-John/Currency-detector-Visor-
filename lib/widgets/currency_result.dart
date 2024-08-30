import 'package:flutter/material.dart';

class CurrencyResult extends StatelessWidget {
  final String currency;

  CurrencyResult({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Detected Currency: $currency',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
