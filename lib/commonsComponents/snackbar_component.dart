import 'package:flutter/material.dart';

class SnackBarComponent extends SnackBar{
  // ignore: annotate_overrides, overridden_fields
  final Color backgroundColor;
  // ignore: annotate_overrides, overridden_fields
  final double elevation;
  // ignore: annotate_overrides, overridden_fields
  final bool showCloseIcon;
  // ignore: annotate_overrides, overridden_fields
  final Color closeIconColor;
  // ignore: annotate_overrides, overridden_fields
  final SnackBarBehavior behavior;
  // ignore: annotate_overrides, overridden_fields
  final DismissDirection dismissDirection;
  // ignore: annotate_overrides, overridden_fields
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