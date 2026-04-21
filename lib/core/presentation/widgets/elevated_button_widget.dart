import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/core/presentation/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? foregroundColor;
  final Color? foregroundHoverColor;
  final Widget? icon;
  final bool readOnly;
  const ElevatedButtonWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      this.width = double.infinity,
      this.height = 50,
      this.backgroundColor = AppColors.gold,
      this.hoverColor = AppColors.lightGold,
      this.foregroundColor,
      this.foregroundHoverColor,
      this.icon,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ButtonStyle(
            alignment: Alignment.center,
            foregroundColor: WidgetStateColor.fromMap({
              WidgetState.any : foregroundColor ?? Colors.white,
              WidgetState.hovered: foregroundHoverColor ?? Colors.white
            }),
            backgroundColor: WidgetStateColor.fromMap({
              WidgetState.hovered: hoverColor ?? AppColors.lightGold,
              WidgetState.any: backgroundColor ?? AppColors.gold
            }),
            shape: WidgetStateProperty.fromMap({
              WidgetState.any : RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(12)))
            }),
            iconAlignment: IconAlignment.end,
            iconColor: WidgetStateColor.fromMap({
              WidgetState.any : Colors.white
            }),
            iconSize: WidgetStateProperty.fromMap({
              WidgetState.any : 20
            })
          ),
          onPressed: readOnly ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Flexible(child:  Text(
            title,
            textScaler: TextScaler.linear(0.8),
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: AppTextStyle.inputTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          )),
          if(icon == null) SizedBox() else Flexible(child: Container(margin: EdgeInsets.fromLTRB(5, 4, 0, 0), child: icon,))
            ],
          ),
        ),
      );
}
