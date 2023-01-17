import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingSlider extends StatefulWidget {
  final List<Widget> items;

  final Widget donePage;

  final Widget? nextButtonIcon;

  final String doneButtonText;

  final Color pageIndicatorColor;

  final Color inactivePageIndicatorColor;

  final Color? backgroundColor;

  final Color? buttonColor;

  final TextStyle? buttonTextStyle;

  const OnboardingSlider({
    super.key,
    required this.items,
    required this.donePage,
    this.nextButtonIcon,
    this.doneButtonText = 'Finish',
    this.pageIndicatorColor = Colors.black,
    this.inactivePageIndicatorColor = const Color.fromARGB(255, 228, 228, 228),
    this.backgroundColor = Colors.white,
    this.buttonColor = Colors.black,
    this.buttonTextStyle,
  });

  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  late PageController pageController;
  int currentPage = 0;

  void onboardingDone() {
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
            ? FloatingActionButton(
                onPressed: () =>
                    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                backgroundColor: widget.buttonColor,
                child: widget.nextButtonIcon,
              )
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
            bottom: 45,
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
