import 'package:flutter/material.dart';

import 'package:flutter_onboarding/flutter_onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const OnboardingSlider(
        items: [
          Center(child: Text('Description Text 1')),
          Center(child: Text('Description Text 2')),
          Center(child: Text('Description Text 3')),
        ],
        donePage: Scaffold(backgroundColor: Colors.black),
        nextButtonIcon: Icon(
          Icons.arrow_right_alt,
          color: Colors.white,
        ),
        buttonTextStyle: TextStyle(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
