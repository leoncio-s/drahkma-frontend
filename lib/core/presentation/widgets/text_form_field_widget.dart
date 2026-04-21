import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFormFieldWidget extends StatelessWidget{
  final String? labelText;
  final String? hintText;
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
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Iterable<String>? autofillHints;

  const TextFormFieldWidget(
    {super.key,
    this.labelText,
    this.hintText,
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
    this.textInputAction,
    this.prefixIcon,
    this.prefixIconColor,
    this.autofillHints
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
      autofillHints: autofillHints,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: autovalidateMode,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmited,
      textInputAction: textInputAction,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: (decoration)?.applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
        counterText: "",
        alignLabelWithHint: false,
        labelText: labelText,
        hintText: hintText ?? labelText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle?.copyWith(
          overflow: TextOverflow.clip,
          leadingDistribution: TextLeadingDistribution.proportional,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderBlue, width: 0.1, strokeAlign: 0.1),
          gapPadding: 1.0
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gold, width: 0.1, strokeAlign: 0.1),
          gapPadding: 1.0
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.expenseRed, width: 0.8, strokeAlign: 0.1),
          gapPadding: 1.0
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor
      )
    );
  }
}