import 'package:drahkma/CommonsComponents/default_layout.dart';
import 'package:drahkma/CommonsComponents/elevated_button_component.dart';
import 'package:drahkma/CommonsComponents/snackbar_component.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:drahkma/commonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';

class NewPasswordFormPage extends StatefulWidget
{
  const NewPasswordFormPage({super.key});

  @override
  State<NewPasswordFormPage> createState() => _NewPassWordFormPage();
}

class _NewPassWordFormPage extends State<NewPasswordFormPage>{
  final TextEditingController _curPasswd = TextEditingController();
  final TextEditingController _newPasswd = TextEditingController();
  final TextEditingController _confNewPasswd = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: _form(),);
  }
  Widget _form(){
    return Form(
      key: _formKey,
      child: Column(
      children: [
        TextFormFieldComponent(
          controller: _curPasswd,
          labelText: "Senha atual", obscureText: true,
          validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          }
          return null;
        }),
        SizedBox(height: 25,),
        TextFormFieldComponent(
          controller: _newPasswd,
          labelText: "Nova Senha", obscureText: true,
          validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          }
          return null;
        }),
        SizedBox(height: 25,),
        TextFormFieldComponent(
          controller: _confNewPasswd,
          labelText: "Confirmar Nova Senha", obscureText: true,
          validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          }
          if(value != _newPasswd.text){
            return "Senhas não conicidem";
          }
          return null;
        }),
        SizedBox(height: 25,),
        ElevatedButtonComponent(title: "Alterar Senha", onPressed: _submitForm, hoverColor: Colors.blueGrey.shade200,),
        SizedBox(height: 25,),
        ElevatedButtonComponent(title: "Voltar", onPressed: (){Navigator.of(context).pop();}, backgroundColor: Colors.grey, hoverColor: Colors.blueGrey.shade200,),
      ],
    ));
  }

  Future<void> _submitForm() async
  {
    if(_formKey.currentState!.validate())
    {
      var snack;
      var ret = await UserService.updatePassword(_curPasswd.text, _newPasswd.text, _confNewPasswd.text);
      if(ret['success'])
      {
        snack = SnackBarComponent(content: Text("Senha alterada com sucesso"), backgroundColor: Colors.green, duration: Duration(seconds: 3),);
        Future.delayed(Duration(seconds: 3), (){
          mounted ? Navigator.of(context).pop() : null;
        });
      }else{
        snack = SnackBarComponent(content: Text(ret['message'])); 
      }
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
        
      }
    }
    return;
  }
}