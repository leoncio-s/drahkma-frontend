import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFormFieldComponent extends StatelessWidget{
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmited;

  const TextFormFieldComponent(
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
    this.decoration = const InputDecoration(),
    this.autovalidateMode, 
    this.readOnly=false,
    this.maxLength,
    this.onFieldSubmited,
    this.textInputAction
    });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: autovalidateMode,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmited,
      textInputAction: textInputAction,
      decoration: (decoration)?.applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
        counterText: "", 
        labelText: labelText,
        alignLabelWithHint: false,
        hintText: labelText,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle!.copyWith(
          overflow: TextOverflow.clip,
          leadingDistribution: TextLeadingDistribution.proportional,
          fontSize: 13,
        )
      )
    );
  }
}