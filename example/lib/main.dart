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
      home: OnBoardingSlider(
        pageCount: 3,
        imageHorizontalOffset: 30,
        skipTextButton: Text('Skip'),
        heroWidgets: [
          Image.asset('assets/Asset 19@2x.png'),
          Image.asset('assets/Asset 20@2x.png'),
          Image.asset('assets/Asset 25@2x.png'),
        ],
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 1'),
              ],
            ),
          ),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 2'),
              ],
            ),
          ),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 3'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
