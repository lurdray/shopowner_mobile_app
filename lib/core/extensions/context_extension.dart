import 'package:flutter/material.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';

extension MediaQueryExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  Size get screenSize => MediaQuery.of(this).size;
  double get screenHeight => screenSize.height;
  double get screenWidth => screenSize.width;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get appBarHeight => AppBar().preferredSize.height;
  double get bodyHeight => screenHeight - statusBarHeight - appBarHeight;
}

extension NavigationExtension on BuildContext {
  Future<T?> push<T extends Object>(
    Widget page, {
    RouteTransition transition = RouteTransition.none,
  }) {
    return Navigator.of(this).push(_createRoute(page, transition));
  }

  void pushReplacement(
    Widget page, {
    RouteTransition transition = RouteTransition.none,
  }) {
    Navigator.of(this).pushReplacement(_createRoute(page, transition));
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  void pushAndRemoveUntil(
    Widget page, {
    RouteTransition transition = RouteTransition.none,
  }) {
    Navigator.of(this).pushAndRemoveUntil(
      _createRoute(page, transition),
      (Route<dynamic> route) => false,
    );
  }

  void popUntil<T>([int popNo = 1]) {
    int count = 0;
    Navigator.of(this).popUntil((route) => count++ >= popNo);
  }

  Route<T> _createRoute<T>(Widget page, RouteTransition transition) {
    switch (transition) {
      case RouteTransition.fadeIn:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case RouteTransition.slideFromRight:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.ease;
            final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );
      case RouteTransition.slideFromBottom:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.ease;
            final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );
      case RouteTransition.scale:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;
            final tween =
                Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            return ScaleTransition(scale: animation.drive(tween), child: child);
          },
        );
      case RouteTransition.none:
        return MaterialPageRoute(builder: (context) => page);
    }
  }
}
