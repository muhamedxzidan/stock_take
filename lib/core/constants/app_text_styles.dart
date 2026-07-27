import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// AppTextStyles provides tablet-optimized font sizes that remain elegant and readable.
class AppTextStyles {
  AppTextStyles._();

  /// Helper to clamp font sizes so they don't over-expand on Tablets/Desktops.
  static double _responsiveFontSize(double baseSize) {
    if (ScreenUtil().screenWidth >= 600) {
      // On Tablet / Desktop: Use balanced font size (baseSize + subtle scaling)
      return baseSize * 1.1;
    }
    return baseSize.sp;
  }

  static TextStyle get heading1 => TextStyle(
        fontSize: _responsiveFontSize(20),
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => TextStyle(
        fontSize: _responsiveFontSize(16),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading3 => TextStyle(
        fontSize: _responsiveFontSize(14),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: _responsiveFontSize(14),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: _responsiveFontSize(12),
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: _responsiveFontSize(11),
        fontWeight: FontWeight.normal,
        color: AppColors.textLight,
      );

  static TextStyle get buttonText => TextStyle(
        fontSize: _responsiveFontSize(13),
        fontWeight: FontWeight.bold,
        color: AppColors.surface,
      );

  static TextStyle get caption => TextStyle(
        fontSize: _responsiveFontSize(10),
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
}
