
import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget{

  final void Function()? onPressed;
  final String title;
  const ElevatedButtonComponent({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
}