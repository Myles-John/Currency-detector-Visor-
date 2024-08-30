import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  final Function(String) onDetect;

  CameraView({required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 100,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Simulate currency detection
              String detectedCurrency = "GH₵";
              onDetect(detectedCurrency);
            },
            child: Text('Detect Currency'),
          ),
        ],
      ),
    );
  }
}
