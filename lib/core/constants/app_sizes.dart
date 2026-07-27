import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AppSizes provides responsive values for padding, spacing, icon sizes, and borders.
class AppSizes {
  AppSizes._();

  static bool get _isTablet => ScreenUtil().screenWidth >= 600;

  static double _width(double value) => _isTablet ? value * 1.1 : value.w;

  static double _height(double value) => _isTablet ? value * 1.1 : value.h;

  static double _radius(double value) => _isTablet ? value * 1.05 : value.r;

  // Spacing & Padding
  static double get p4 => _width(4);
  static double get p8 => _width(8);
  static double get p12 => _width(12);
  static double get p16 => _width(16);
  static double get p20 => _width(20);
  static double get p24 => _width(24);
  static double get p32 => _width(32);

  // Vertical gaps
  static double get h4 => _height(4);
  static double get h8 => _height(8);
  static double get h12 => _height(12);
  static double get h16 => _height(16);
  static double get h20 => _height(20);
  static double get h24 => _height(24);
  static double get h32 => _height(32);

  // Radius
  static double get r8 => _radius(8);
  static double get r12 => _radius(12);
  static double get r16 => _radius(16);
  static double get r24 => _radius(24);

  // Icon Sizes
  static double get iconSm => _width(16);
  static double get iconMd => _width(24);
  static double get iconLg => _width(32);

  // Card & Button Heights
  static double get buttonHeight => _height(48);
  static double get inputHeight => _height(52);
  static double get cardElevation => 2.0;
}
