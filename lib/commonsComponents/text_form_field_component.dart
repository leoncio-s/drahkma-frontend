import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFormFieldComponent extends StatelessWidget{
  String? labelText;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputType? keyboardType;
  bool obscureText;
  String obscuringCharacter;
  bool autofocus;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  InputDecoration? decoration;

  TextFormFieldComponent(
    {super.key,
    required this.labelText,
    this.controller,
    this.keyboardType,
    this.focusNode,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autofocus = false,
    this.validator, 
    this.inputFormatters,
    this.decoration = const InputDecoration()
    });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: (decoration)?.applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
        counterText: "", 
        labelText: labelText,
        alignLabelWithHint: false,
        hintText: labelText,
        // errorMaxLines: 1
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle!.copyWith(
          // height: 4,
          overflow: TextOverflow.clip,
          leadingDistribution: TextLeadingDistribution.proportional,
          fontSize: 13,
        )
      )
    );
  }
}