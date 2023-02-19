# Flutter Onboarding
[![GitHub last commit](https://img.shields.io/github/last-commit/C4s4r/flutter_onboarding?label=last%20updated)](https://github.com/C4s4r/flutter_onboarding/commits/)
[![GitHub](https://img.shields.io/github/license/C4s4r/flutter_onboarding)](https://opensource.org/licenses/BSD-3-Clause)


A package that provides an animated onboarding experience to display different pages. It holds a progress indicator and can be navigated by swipe or a `FloatingActionButton`.

## Getting Started

As usual, begin by adding the package to your pubspec.yaml file, see [install instruction](https://pub.dev/packages/animated_popup_dialog/install).

Here is a basic setup with the `OnboardingSlider` widget:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_onboarding/flutter_onboarding.dart';

class GettingStartedExample extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
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
    );
  }
}
```

## Different properties to set
You can set the following properties:
* **`items`**: The items that should be displayed on the different pages
* **`donePage`**: The page that should be navigated to, when the onboarding is done
* **`onDone`**: A function that is executed before navigating to the `donePage` widget
* **`nextButtonIcon`**: The icon that should be displayed inside the `FloatingActionButton`, unless the active page is the last one
* **`doneButtonText`**: The text that should be displayed inside the `FloatingActionButton.extended` on the last page
* **`pageIndicatorColor`**: The active color of the progress indicator
* **`inactivePageIndicatorColor`**: The secondary color of the progress indicator
* **`backgroundColor`**: The page background color
* **`buttonColor`**: The button color that is used for both the `FloatingActionButton` and the `FloatingActionButton.extended`
* **`buttonTextStyle`**: The [TextStyle] that is used for the text insiede the `FloatingActionButton.extended` on the last page
* **`hideButtonOnPage`**: A list of pages on which the button should be invisible
