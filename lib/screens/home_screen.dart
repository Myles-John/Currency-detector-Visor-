import 'package:currency_detector/screens/result_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/camera_view.dart';

class HomeScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Detector(Visor)'),
      ),
      body: CameraView(
        onDetect: (detectedCurrency) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(currency: detectedCurrency),
            ),
          );
        },
      ),
    );
  }
}
