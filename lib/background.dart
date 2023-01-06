import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Background extends StatelessWidget {
  final List<Widget> backgrounds;
  final int pageCount;
  final double speed;
  final double imageVerticalOffset;
  final double imageHorizontalOffset;
  final Widget child;

  const Background({
    Key? key,
    required this.backgrounds,
    required this.pageCount,
    required this.speed,
    required this.imageVerticalOffset,
    required this.imageHorizontalOffset,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(backgrounds.length == pageCount);

    return Stack(
      children: [
        for (int i = 0; i < pageCount; i++)
          BackgroundImage(
            imageHorizontalOffset: imageHorizontalOffset,
            imageVerticalOffset: imageVerticalOffset,
            id: pageCount - i,
            speed: speed,
            background: backgrounds[pageCount - i - 1],
          ),
        child,
      ],
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final int id;
  final Widget background;
  final double imageVerticalOffset;
  final double speed;
  final double imageHorizontalOffset;

  const BackgroundImage({
    Key? key,
    required this.id,
    required this.speed,
    required this.background,
    required this.imageVerticalOffset,
    required this.imageHorizontalOffset,
  }) : super(key: key);

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
      child: Container(child: background),
    );
  }
}

class BackgroundBody extends StatelessWidget {
  final List<Widget> bodies;
  final PageController controller;
  final Function function;
  final int pageCount;

  const BackgroundBody({
    Key? key,
    required this.bodies,
    required this.controller,
    required this.function,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(bodies.length == pageCount);

    return PageView(
      physics: const ClampingScrollPhysics(),
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
  final int pageCount;
  final Color? controllerColor;
  final bool indicatorAbove;
  final double indicatorPosition;

  const BackgroundController({
    Key? key,
    required this.currentPage,
    required this.pageCount,
    required this.controllerColor,
    required this.indicatorAbove,
    required this.indicatorPosition,
  }) : super(key: key);

  /// List of the slide indicators
  List<Widget> _buildPageIndicator(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < pageCount; i++) {
      list.add(i == currentPage ? _indicator(true, context) : _indicator(false, context));
    }
    return list;
  }

  /// Slide controller / indicator
  Widget _indicator(bool isActive, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: indicatorAbove ? indicatorPosition : 28),
      height: 8.0,
      width: isActive ? 28.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? controllerColor ?? Colors.white : (controllerColor ?? Colors.white).withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return indicatorAbove
        ? Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(context),
            ),
          )
        : currentPage == pageCount - 1
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(context),
                ),
              );
  }
}

class FinalButton extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final int pageCount;
  final bool addButton;
  final Function? onPageFinish;
  final Color? buttonBackgroundColor;
  final TextStyle buttonTextStyle;
  final String? buttonText;
  final bool hasSkip;
  final Icon skipIcon;

  const FinalButton({
    Key? key,
    required this.currentPage,
    required this.pageController,
    required this.pageCount,
    this.onPageFinish,
    this.buttonBackgroundColor,
    this.buttonText,
    required this.buttonTextStyle,
    required this.addButton,
    required this.hasSkip,
    required this.skipIcon,
  }) : super(key: key);

  /// Switch to next slide using the FloatingActionButton
  void _goToNextPage(BuildContext context) {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return addButton
        ? hasSkip
            ? AnimatedContainer(
                padding:
                    currentPage == pageCount - 1 ? const EdgeInsets.symmetric(horizontal: 30) : const EdgeInsets.all(0),
                width: currentPage == pageCount - 1 ? MediaQuery.of(context).size.width - 30 : 60,
                duration: const Duration(milliseconds: 100),
                child: currentPage == pageCount - 1
                    ? FloatingActionButton.extended(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        onPressed: () => onPageFinish?.call(),
                        elevation: 0,
                        label: buttonText == null
                            ? const SizedBox.shrink()
                            : Text(
                                buttonText!,
                                style: buttonTextStyle,
                              ),
                        backgroundColor: buttonBackgroundColor,
                      )
                    : FloatingActionButton(
                        onPressed: () => _goToNextPage(context),
                        elevation: 0,
                        backgroundColor: buttonBackgroundColor,
                        child: skipIcon,
                      ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width - 30,
                child: FloatingActionButton.extended(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () => onPageFinish?.call(),
                  elevation: 0,
                  label: buttonText == null
                      ? const SizedBox.shrink()
                      : Text(
                          buttonText!,
                          style: buttonTextStyle,
                        ),
                  backgroundColor: buttonBackgroundColor,
                ))
        : const SizedBox.shrink();
  }
}

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page ?? 0;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}
