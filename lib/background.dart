import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_onboarding/page_offset_provider.dart';

class Background extends StatelessWidget {
  final Widget child;
  final int totalPage;
  final List<Widget> background;
  final double speed;
  final double imageVerticalOffset;
  final double imageHorizontalOffset;

  Background({
    required this.imageVerticalOffset,
    required this.child,
    required this.totalPage,
    required this.background,
    required this.speed,
    required this.imageHorizontalOffset,
  });

  @override
  Widget build(BuildContext context) {
    assert(background.length == totalPage);
    return Stack(
      children: [
        for (int i = 0; i < totalPage; i++)
          BackgroundImage(
              imageHorizontalOffset: imageHorizontalOffset,
              imageVerticalOffset: imageVerticalOffset,
              id: totalPage - i,
              speed: speed,
              background: background[totalPage - i - 1]),
        child,
      ],
    );
  }
}

class BackgroundBody extends StatelessWidget {
  final PageController controller;
  final Function function;
  final int totalPage;
  final List<Widget> bodies;

  BackgroundBody({
    required this.controller,
    required this.function,
    required this.totalPage,
    required this.bodies,
  });

  @override
  Widget build(BuildContext context) {
    assert(bodies.length == totalPage);
    return PageView(
      physics: ClampingScrollPhysics(),
      controller: controller,
      onPageChanged: (value) {
        function(value);
      },
      children: bodies,
    );
  }
}

class BackgroundController extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final Color? controllerColor;
  final bool indicatorAbove;
  final double indicatorPosition;

  BackgroundController({
    required this.currentPage,
    required this.totalPage,
    required this.controllerColor,
    required this.indicatorAbove,
    required this.indicatorPosition,
  });

  @override
  Widget build(BuildContext context) {
    return indicatorAbove
        ? Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(context),
            ),
          )
        : currentPage == totalPage - 1
            ? SizedBox.shrink()
            : Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(context),
                ),
              );
  }

  /// List of the slides Indicators.
  List<Widget> _buildPageIndicator(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < totalPage; i++) {
      list.add(i == currentPage
          ? _indicator(true, context)
          : _indicator(false, context));
    }
    return list;
  }

  /// Slide Controller / Indicator.
  Widget _indicator(bool isActive, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: indicatorAbove ? indicatorPosition : 28),
      height: 8.0,
      width: isActive ? 28.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? controllerColor ?? Colors.white
            : (controllerColor ?? Colors.white).withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class BackgroundFinalButton extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final int totalPage;
  final bool addButton;
  final Function? onPageFinish;
  final Color? buttonBackgroundColor;
  final TextStyle buttonTextStyle;
  final String? buttonText;
  final bool hasSkip;
  final Icon skipIcon;

  BackgroundFinalButton({
    required this.currentPage,
    required this.pageController,
    required this.totalPage,
    this.onPageFinish,
    this.buttonBackgroundColor,
    this.buttonText,
    required this.buttonTextStyle,
    required this.addButton,
    required this.hasSkip,
    required this.skipIcon,
  });

  @override
  Widget build(BuildContext context) {
    return addButton
        ? hasSkip
            ? AnimatedContainer(
                padding: currentPage == totalPage - 1
                    ? EdgeInsets.symmetric(horizontal: 30)
                    : EdgeInsets.all(0),
                width: currentPage == totalPage - 1
                    ? MediaQuery.of(context).size.width - 30
                    : 60,
                duration: Duration(milliseconds: 100),
                child: currentPage == totalPage - 1
                    ? FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        onPressed: () => onPageFinish?.call(),
                        elevation: 0,
                        label: buttonText == null
                            ? SizedBox.shrink()
                            : Text(
                                buttonText!,
                                style: buttonTextStyle,
                              ),
                        backgroundColor: buttonBackgroundColor,
                      )
                    : FloatingActionButton(
                        onPressed: () => _goToNextPage(context),
                        elevation: 0,
                        child: skipIcon,
                        backgroundColor: buttonBackgroundColor,
                      ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width - 30,
                child: FloatingActionButton.extended(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () => onPageFinish?.call(),
                  elevation: 0,
                  label: buttonText == null
                      ? SizedBox.shrink()
                      : Text(
                          buttonText!,
                          style: buttonTextStyle,
                        ),
                  backgroundColor: buttonBackgroundColor,
                ))
        : SizedBox.shrink();
  }

  /// Switch to Next Slide using the Floating Action Button.
  void _goToNextPage(BuildContext context) {
    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}


class BackgroundImage extends StatelessWidget {
  final int id;
  final Widget background;
  final double imageVerticalOffset;
  final double speed;
  final double imageHorizontalOffset;

  BackgroundImage({
    required this.id,
    required this.speed,
    required this.background,
    required this.imageVerticalOffset,
    required this.imageHorizontalOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Stack(children: [
          Positioned(
            top: imageVerticalOffset,
            left: MediaQuery.of(context).size.width * ((id - 1) * speed) -
                speed * notifier.offset +
                imageHorizontalOffset,
            child: child!,
          ),
        ]);
      },
      child: Container(
        child: background,
      ),
    );
  }
}