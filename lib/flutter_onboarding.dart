import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Displays an onboarding experience with different pages,
/// a [FloatingActionButton] and a progress indicator.
class OnboardingSlider extends StatefulWidget {
  /// The items that should be displayed on the different pages
  final List<Widget> items;

  /// The page that should be navigated to, when the onboarding is done
  final Widget donePage;

  /// A function that is executed before navigating to the `donePage` widget
  final VoidCallback? onDone;

  /// The icon that should be displayed inside the [FloatingActionButton],
  /// unless the active page is the last one
  final Widget? nextButtonIcon;

  /// The text that should be displayed inside the [FloatingActionButton.extended]
  /// on the last page
  final String doneButtonText;

  /// The active color of the progress indicator
  final Color pageIndicatorColor;

  /// The secondary color of the progress indicator
  final Color inactivePageIndicatorColor;

  /// The page background color
  final Color? backgroundColor;

  /// The button color that is used for both the [FloatingActionButton]
  /// and the [FloatingActionButton.extended]
  final Color? buttonColor;

  /// The [TextStyle] that is used for the text insiede the
  /// [FloatingActionButton.extended] on the last page
  final TextStyle? buttonTextStyle;

  final List<int> hideButtonOnPage;

  const OnboardingSlider({
    super.key,
    required this.items,
    required this.donePage,
    this.onDone,
    this.nextButtonIcon,
    this.doneButtonText = 'Finish',
    this.pageIndicatorColor = Colors.black,
    this.inactivePageIndicatorColor = const Color.fromARGB(255, 228, 228, 228),
    this.backgroundColor = Colors.white,
    this.buttonColor = Colors.black,
    this.buttonTextStyle,
    this.hideButtonOnPage = const [],
  });

  @override
  State<OnboardingSlider> createState() => OnboardingSliderState();
}

class OnboardingSliderState extends State<OnboardingSlider> {
  late PageController pageController;
  int currentPage = 0;

  /// Can be called from outside in order to navigate the next page
  /// manually. This can be useful, for example, when there's another
  /// button despite the FloatingActionButton, that should influence the navigation.
  ///
  /// The returned [Future] resolves when the animation completes.
  Future<void> nextPage() {
    return pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onboardingDone() {
    widget.onDone?.call();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
        pageBuilder: (context, animation, secondaryAnimation) => widget.donePage,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      floatingActionButton: AnimatedContainer(
        padding: currentPage == widget.items.length - 1 ? const EdgeInsets.symmetric(horizontal: 30) : null,
        width: currentPage == widget.items.length - 1 ? MediaQuery.of(context).size.width - 30 : 60,
        duration: const Duration(milliseconds: 100),
        child: currentPage != widget.items.length - 1
            ? !widget.hideButtonOnPage.contains(currentPage)
                // Show the normal FloatingActionButton
                ? FloatingActionButton(
                    onPressed: () =>
                        pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    backgroundColor: widget.buttonColor,
                    child: widget.nextButtonIcon,
                  )
                // Hide the button on this page
                : const SizedBox.shrink()
            : FloatingActionButton.extended(
                onPressed: onboardingDone,
                label: Text(widget.doneButtonText, style: widget.buttonTextStyle),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                backgroundColor: widget.buttonColor,
              ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Page content
          PageView.builder(
            controller: pageController,
            itemCount: widget.items.length,
            scrollBehavior: const CupertinoScrollBehavior(),
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              return Container(
                color: widget.backgroundColor,
                child: widget.items[index],
              );
            },
          ),
          // Page indicator
          Positioned(
            bottom: !Platform.isIOS ? 45 : 90,
            child: SmoothPageIndicator(
              controller: pageController,
              count: widget.items.length,
              effect: ExpandingDotsEffect(
                activeDotColor: widget.pageIndicatorColor,
                dotColor: widget.inactivePageIndicatorColor,
                dotWidth: 10,
                dotHeight: 10,
                offset: 20,
                expansionFactor: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
