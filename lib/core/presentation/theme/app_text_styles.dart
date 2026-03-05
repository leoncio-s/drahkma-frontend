import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';


class AppTextStyle
{
  static final String _fontFamily = "Montserrat";
  static final List<String> _fontFallback = ['Inter', 'sans-serif'];

  static TextStyle  get inputTextStyle=> TextStyle(
    color: Colors.white, 
    decorationColor: Colors.blueAccent,
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontWeight: FontWeight.w400
  );

  static TextStyle get linkTextStyle => TextStyle(
    color: AppColors.gold,
    decorationColor: Colors.white,
    fontSize: 15.5,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontWeight: FontWeight.w600
  );

  static TextStyle get linkHoverTextStyle => TextStyle(
    color: AppColors.gold,
    decorationColor: Colors.white,
    fontSize: 15.5,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline
  );

  static TextStyle get errorTextStyle => TextStyle(
    color: AppColors.redError,
    decorationColor: Colors.white,
    fontSize: 15,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontWeight: FontWeight.normal
  );

}
