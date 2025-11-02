import 'dart:async';
import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/commonsComponents/default_layout.dart';
import 'package:drahkma/commonsComponents/elevated_button_component.dart';
import 'package:drahkma/commonsComponents/modal.dart';
import 'package:drahkma/commonsComponents/snackbar_component.dart';
import 'package:drahkma/commonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';

class ForgetPasswordCodepage extends StatefulWidget{
  final String email;
  const ForgetPasswordCodepage({super.key, required this.email});
  
  @override
  State<ForgetPasswordCodepage> createState()=>ForgetPasswordCodepageState();
}

class ForgetPasswordCodepageState extends State<ForgetPasswordCodepage>{
  bool notShowPassword = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notShowPassword = true;
    email.text = widget.email;
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: DefaultLayout(child: _form(),),);


  _form(){

    return Form(
      key: _formKey,
      child: Column(
      children: [
        TextFormFieldComponent(labelText: 'E-mail', controller: email, readOnly: true,),
        const SizedBox(height: 20,),
        TextFormFieldComponent(labelText:'Código', controller: code, autovalidateMode: AutovalidateMode.onUserInteraction, maxLength: 6, validator: (value){
          if(value != null && (value.length < 6 || value.length > 6)){
            return "Código Inválido";
          }
          return null;
        },),
        const SizedBox(height: 20,),
        _passwordField("Senha", password),
        const SizedBox(height: 20,),
        _passwordField('Confirmação de Senha', confPassword),
        const SizedBox(height: 20,),
        ElevatedButtonComponent(title: "Alterar Senha", onPressed: ()async{
          if(_formKey.currentState!.validate()){
            var _modal = modal(context, "loading", barrierDismissible: false);
            // showDialog(context: context, builder: showModal);
            try{
              var ret = await AuthService.forgetPasswordCode(email.text, code.text, password.value.text, confPassword.value.text);
              _modal();
              if(ret['message'] != null)
              {
                SnackBar snackBar= SnackBarComponent(content: Text(ret['message']), backgroundColor: Colors.green[600]!);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                await Future.delayed(const Duration(microseconds: 300));
                Navigator.of(context).pushReplacementNamed('/auth/login');
              }else{
                SnackBar snackBar = SnackBarComponent(content: Text(ret['error']));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }on Exception catch(ex){
              _modal();
              SnackBar snackBar = SnackBarComponent(content: Text(ex.toString()));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        })
      ],
    ));
  }

  _passwordField(String label, TextEditingController controller){
    return TextFormFieldComponent(
      maxLength: 20,
      labelText: label,
      obscureText: notShowPassword,
        obscuringCharacter: "*",
        keyboardType: TextInputType.visiblePassword,
        autovalidateMode: AutovalidateMode.onUnfocus,
        decoration: InputDecoration(
            suffixIcon: IconButton.outlined(
                splashRadius: 0.1,
                enableFeedback: true,
                isSelected: false,
                onPressed: () {
                  setState(() {
                    notShowPassword = !notShowPassword;
                  });
                },
                icon: Icon(notShowPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined))),
        validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          }else{
            setState(() {
              controller.text = value!;
            });
          }
          return null;
        });
  }
}