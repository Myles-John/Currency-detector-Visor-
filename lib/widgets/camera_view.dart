import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import the http package for making HTTP requests
import 'dart:convert';  // Import for JSON encoding and decoding

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
            onPressed: () async {
              // Make an HTTP GET request to your backend URL
              final response = await http.get(Uri.parse('http://localhost:3000/detect_currency'));
              
              // Check if the request was successful
              if (response.statusCode == 200) {
                // Decode the JSON response
                final data = json.decode(response.body);
                String detectedCurrency = data['currency'];
                
                // Trigger the onDetect callback with the detected currency
                onDetect(detectedCurrency);
              } else {
                // Handle the error if the request fails
                print('Failed to load currency');
              }
            },
            child: Text('Detect Currency'),
          ),
        ],
      ),
    );
  }
}
