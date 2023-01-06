import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final int currentPage;
  final int pageCount;
  final Function onSkip;
  final Function? onFinish;
  final Widget? finishButton;
  final Widget? skipTextButton;
  final Widget? leading;
  final Widget? middle;
  final Color headerBackgroundColor;

  const OnboardingNavigationBar({
    Key? key,
    required this.currentPage,
    required this.pageCount,
    required this.onSkip,
    this.onFinish,
    this.finishButton,
    this.skipTextButton,
    this.leading,
    this.middle,
    required this.headerBackgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      leading: leading,
      middle: middle,
      trailing: currentPage == pageCount - 1
          ? finishButton == null
              ? const SizedBox.shrink()
              : Container(
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: TextButton(
                    onPressed: () => onFinish?.call(),
                    child: finishButton!,
                  ),
                )
          : skipTextButton == null
              ? const SizedBox.shrink()
              : Container(
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: TextButton(
                    onPressed: () => onSkip.call(),
                    child: skipTextButton!,
                  ),
                ),
      border: const Border(
        bottom: BorderSide(color: Colors.transparent),
      ),
      backgroundColor: headerBackgroundColor,
    );
  }
}
