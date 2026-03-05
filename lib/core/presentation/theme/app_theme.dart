import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme 
{
  static ThemeData get light=> ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      primary: AppColors.gold,
      error: AppColors.expenseRed,
      surface: AppColors.blueNavy
      ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.blueNavy,
      foregroundColor: Colors.white,
    )
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blueNavy,
      primary: AppColors.blueNavy,
      secondary: AppColors.gold,
      brightness: Brightness.dark
      )
  );
}