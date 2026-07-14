import 'package:flutter/material.dart';

double responsiveFontSize(
  BuildContext context, {
  double factor = 0.045,
  double min = 14,
  double max = 22,
}) {
  final width = MediaQuery.of(context).size.width;
  return (width * factor).clamp(min, max).toDouble();
}

TextScaler responsiveTextScaler(
  BuildContext context, {
  double minScaleFactor = 0.8,
  double maxScaleFactor = 1.4,
}) {
  return MediaQuery.textScalerOf(context).clamp(
    minScaleFactor: minScaleFactor,
    maxScaleFactor: maxScaleFactor,
  );
}

double principalCardScaller(double widthSize, {double maxscaller = 2.0}) {
  double scaller = 1.0;
  if (widthSize < 200) {
    scaller = 1.0;
  } else {
    scaller = widthSize * 0.10;
  }
  if (scaller > maxscaller) {
    return maxscaller;
  }
  return scaller;
}
