import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef Closure = Function();
typedef StringClosure = Function(String?);
typedef BoolClosure = Function(bool?);
typedef IntClosure = Function(int?);
typedef AnyClosure<T> = Function(T?);

class ui {
  static final ui instance = ui._instance();
  factory ui() {
    return instance;
  }
  ui._instance();
  Icon? backIcon;
  var tintColor = Colors.blue;
  var backgroundColor = Colors.white;
  var naviBarBackgroundColor = Colors.white;
  var bottomBarColor = Colors.white;
  var naviBarTitleStyle =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
}

extension Screen on double {
  static double get dpr => window.devicePixelRatio;
  static double get width => window.physicalSize.width / dpr;
  static double get height => window.physicalSize.height / dpr;
  static double get statusBarHeight => window.padding.top / dpr;
  static double get bottomSafeBarHeight => window.padding.bottom / dpr;
  static double get tabBarHeight =>
      (defaultTargetPlatform == TargetPlatform.android)
          ? kBottomNavigationBarHeight
          : 50;

  static double scaleWidth(double width, double scaleW) {
    return width * Screen.width / scaleW;
  }

  static double scaleHeight(double height, double scaleH) {
    return height * Screen.height / scaleH;
  }

  double get scaleW => Screen.scaleWidth(this, 375);
  double get scaleH => Screen.scaleHeight(this, 812);
  double onScaleH(double width, double scaleW) {
    if (width == 0) {
      return 0;
    }
    return width * this / scaleW;
  }
}

extension Hex on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color init(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
