import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef Closure = Function();
typedef StringClosure = Function(String?);
typedef BoolClosure = Function(bool?);
typedef IntClosure = Function(int?);
typedef AnyClosure<T> = Function(T?);

// ignore: camel_case_types
// ignore: camel_case_types
class UI {
  static final UI instance = UI._instance();
  factory UI() {
    return instance;
  }
  UI._instance();
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey();
  static BuildContext? context;
  // ignore: library_private_types_in_public_api
  static _Style style = _Style();
  // ignore: library_private_types_in_public_api
  static _Screen screen = _Screen();
  static launchOf(BuildContext context) {
    UI.context = context;
  }
}

class _Style {
  Image? back;
  var tintColor = Colors.black;
  var backgroundColor = Colors.white;
  var naviBarBackgroundColor = Colors.white;
  var bottomBarColor = Colors.white;
  var naviBarTitleStyle = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  var naviBarElevation = 0.0;
  var leadingWidth = 44.0;
  var naviBarLeftPadding = 20.0;
  var naviBarRightPadding = 15.0;
}

class _Screen {
  double get dpr => (UI.context != null)
      ? View.of(UI.context!).devicePixelRatio
      : window.devicePixelRatio;
  double get width => (UI.context != null)
      ? View.of(UI.context!).physicalSize.width / dpr
      : window.physicalSize.width / dpr;
  double get height => (UI.context != null)
      ? View.of(UI.context!).physicalSize.height / dpr
      : window.physicalSize.height / dpr;
  double get statusBarHeight => (UI.context != null)
      ? View.of(UI.context!).padding.top / dpr
      : window.padding.top / dpr;
  double get bottomSafeBarHeight => (UI.context != null)
      ? View.of(UI.context!).padding.bottom / dpr
      : window.padding.bottom / dpr;
  double get tabBarHeight => (defaultTargetPlatform == TargetPlatform.android)
      ? kBottomNavigationBarHeight
      : 50;

  static double scaleWidth(double width, double scaleW) {
    return width * UI.screen.width / scaleW;
  }

  static double scaleHeight(double height, double scaleH) {
    return height * UI.screen.height / scaleH;
  }
}

extension on double {
  // ignore: unused_element
  double get scaleW => _Screen.scaleWidth(this, 375);
  // ignore: unused_element
  double get scaleH => _Screen.scaleHeight(this, 812);
  // ignore: unused_element
  double onScaleH(double width, double scaleW) {
    if (width == 0) {
      return 0;
    }
    return width * this / scaleW;
  }
}

extension Hex on Color {
  static Color init(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
