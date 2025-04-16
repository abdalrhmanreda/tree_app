import 'package:flutter/material.dart';

class FirstFadeTransaction extends PageRouteBuilder {
  final Widget page;

  FirstFadeTransaction(this.page)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: page,
          ),
        );
}

class SecondFadeTransaction extends PageRouteBuilder {
  final Widget page;

  SecondFadeTransaction(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return FadeTransition(
              opacity: animation,
              child: page,
            );
          },
        );
}
