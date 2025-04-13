import 'package:flutter/material.dart';

class SnackBarComponent extends SnackBar{
  final Color backgroundColor;
  final double elevation;
  final bool showCloseIcon;
  final Color closeIconColor;
  final SnackBarBehavior behavior;
  final DismissDirection dismissDirection;
  final Duration duration;
  const SnackBarComponent({
    super.key,
    required super.content,
    this.backgroundColor = Colors.red,
    this.elevation = 10.0,
    this.showCloseIcon = true,
    this.closeIconColor = Colors.white,
    this.behavior = SnackBarBehavior.floating,
    this.dismissDirection = DismissDirection.startToEnd,
    this.duration = const Duration(seconds: 5)
    });
}