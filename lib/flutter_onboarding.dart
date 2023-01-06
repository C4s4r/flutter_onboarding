library flutter_onboarding_slider;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_onboarding/navigation_bar.dart';
import 'package:flutter_onboarding/page_offset_provider.dart';

import 'background.dart';

export 'background.dart';

class OnBoardingSlider extends StatefulWidget {
  /// Number of total pages
  final int pageCount;

  /// NavigationBar color
  final Color headerBackgroundColor;

  /// List of widgets to be shown in the background.
  /// Can be any picture or illustration.
  final List<Widget> background;

  /// The animation speed for the [background]
  final double speed;

  /// Background color of the screen (apart from the NavigationBar)
  final Color? pageBackgroundColor;

  /// Background gradient of the screen (apart from the NavigationBar)
  final Gradient? pageBackgroundGradient;

  /// Callback to be executed when clicked on the [finishButton]
  final Function? onFinish;

  /// NavigationBar trailing widget when on last screen
  final Widget? trailing;

  /// NavigationBar trailing widget when not on last screen
  final Widget? skipTextButton;

  /// The main content ont the screen displayed above [background]
  final List<Widget> pageBodies;

  /// Callback to be executed when clicked on the last pages bottom button
  final Function? trailingFunction;

  /// Color of the bottom button on the last page
  final Color? finishButtonColor;

  /// Text inside last pages bottom button
  final String? finishButtonText;

  /// Text style for text inside last pages bottom button
  final TextStyle finishButtonTextStyle;

  /// Color of the bottom page indicators
  final Color? controllerColor;

  /// Toggle bottom button
  final bool addButton;

  /// Toggle bottom page controller visibilty
  final bool addController;

  /// Defines the vertical offset of the [background]
  final double imageVerticalOffset;

  /// Defines the horizontal offset of the [background]
  final double imageHorizontalOffset;

  /// Leading widget of the navigationBar
  final Widget? leading;

  /// Middle widget of the navigationBar
  final Widget? middle;

  /// Whether to show the FloatingActionButton or not
  final bool hasFloatingButton;

  /// Whether to show the skip button at the bottom or not
  final bool hasSkip;

  /// Icon inside the skip button
  final Icon skipIcon;

  /// Wether the indicator should be located on top of the screen
  final bool indicatorAbove;

  /// Distance of indicators from bottom
  final double indicatorPosition;

  const OnBoardingSlider({
    Key? key,
    required this.pageCount,
    required this.headerBackgroundColor,
    required this.background,
    required this.speed,
    required this.pageBodies,
    this.onFinish,
    this.trailingFunction,
    this.trailing,
    this.skipTextButton,
    this.pageBackgroundColor,
    this.pageBackgroundGradient,
    this.finishButtonColor,
    this.finishButtonText,
    this.controllerColor,
    this.addController = true,
    this.addButton = true,
    this.imageVerticalOffset = 0,
    this.imageHorizontalOffset = 0,
    this.leading,
    this.middle,
    this.hasFloatingButton = true,
    this.hasSkip = true,
    this.finishButtonTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
    this.skipIcon = const Icon(
      Icons.arrow_forward,
      color: Colors.white,
    ),
    this.indicatorAbove = false,
    this.indicatorPosition = 90,
  }) : super(key: key);

  @override
  _OnBoardingSliderState createState() => _OnBoardingSliderState();
}

class _OnBoardingSliderState extends State<OnBoardingSlider> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  /// Slides to the next page
  void slideNext(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Skips to the last page
  void _skip() {
    _pageController.jumpToPage(widget.pageCount - 1);

    setState(() {
      _currentPage = widget.pageCount - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        backgroundColor: widget.pageBackgroundColor,
        floatingActionButton: widget.hasFloatingButton
            ? FinalButton(
                buttonTextStyle: widget.finishButtonTextStyle,
                skipIcon: widget.skipIcon,
                addButton: widget.addButton,
                currentPage: _currentPage,
                pageController: _pageController,
                pageCount: widget.pageCount,
                onPageFinish: widget.onFinish,
                buttonBackgroundColor: widget.finishButtonColor,
                buttonText: widget.finishButtonText,
                hasSkip: widget.hasSkip,
              )
            : const SizedBox.shrink(),
        body: CupertinoPageScaffold(
          navigationBar: OnboardingNavigationBar(
            leading: widget.leading,
            middle: widget.middle,
            pageCount: widget.pageCount,
            currentPage: _currentPage,
            onSkip: _skip,
            headerBackgroundColor: widget.headerBackgroundColor,
            onFinish: widget.trailingFunction,
            finishButton: widget.trailing,
            skipTextButton: widget.skipTextButton,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: widget.pageBackgroundGradient,
              color: widget.pageBackgroundColor,
            ),
            child: SafeArea(
              child: Background(
                imageHorizontalOffset: widget.imageHorizontalOffset,
                imageVerticalOffset: widget.imageVerticalOffset,
                backgrounds: widget.background,
                speed: widget.speed,
                pageCount: widget.pageCount,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BackgroundBody(
                          controller: _pageController,
                          function: slideNext,
                          pageCount: widget.pageCount,
                          bodies: widget.pageBodies,
                        ),
                      ),
                      widget.addController
                          ? BackgroundController(
                              indicatorPosition: widget.indicatorPosition,
                              indicatorAbove: widget.indicatorAbove,
                              currentPage: _currentPage,
                              pageCount: widget.pageCount,
                              controllerColor: widget.controllerColor,
                            )
                          : const SizedBox.shrink(),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
