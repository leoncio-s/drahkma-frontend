
import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget{

  final void Function()? onPressed;
  final String title;
  final double width;
  final double height;
  final Color?  backgroundColor;
  final Color?  hoverColor;
  final Color? foregroundColor;
  const ElevatedButtonComponent({super.key, required this.title, required this.onPressed, this.width=double.infinity, this.height=50, this.backgroundColor, this.hoverColor=Colors.blueGrey, this.foregroundColor});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> state){
            if(state.contains(WidgetState.hovered) && hoverColor != null) return hoverColor!;
            return backgroundColor ?? Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve(state);
          })
        ),
        onPressed: onPressed,
        child: Text(title, textScaler: TextScaler.linear(0.8), overflow: TextOverflow.fade, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: foregroundColor),),
      ),
    );
}