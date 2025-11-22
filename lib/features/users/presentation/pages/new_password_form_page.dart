
import 'package:drahkma/features/users/data/datasources/user_remote_datasource.dart';
import 'package:drahkma/presentation/widgets/default_layout_widget.dart';
import 'package:drahkma/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/presentation/widgets/text_form_field_widget.dart';
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
    return DefaultLayoutWidget(child: _form(),);
  }
  Widget _form(){
    return Form(
      key: _formKey,
      child: Column(
      children: [
        TextFormFieldWidget(
          controller: _curPasswd,
          labelText: "Senha atual", obscureText: true,
          validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          }
          return null;
        }),
        SizedBox(height: 25,),
        TextFormFieldWidget(
          controller: _newPasswd,
          labelText: "Nova Senha", obscureText: true,
          validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          }
          return null;
        }),
        SizedBox(height: 25,),
        TextFormFieldWidget(
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
        ElevatedButtonWidget(title: "Alterar Senha", onPressed: _submitForm, hoverColor: Colors.blueGrey.shade200,),
        SizedBox(height: 25,),
        ElevatedButtonWidget(title: "Voltar", onPressed: (){Navigator.of(context).pop();}, backgroundColor: Colors.grey, hoverColor: Colors.blueGrey.shade200,),
      ],
    ));
  }

  Future<void> _submitForm() async
  {
    if(_formKey.currentState!.validate())
    {
      SnackBarWidget snack;
      var ret = await UserRemoteDatasource.updatePassword(_curPasswd.text, _newPasswd.text, _confNewPasswd.text);
      if(ret['success'])
      {
        snack = SnackBarWidget(content: Text("Senha alterada com sucesso"), backgroundColor: Colors.green, duration: Duration(seconds: 3),);
        Future.delayed(Duration(seconds: 3), (){
          mounted ? Navigator.of(context).pop() : null;
        });
      }else{
        snack = SnackBarWidget(content: Text(ret['message'])); 
      }
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
        
      }
    }
    return;
  }
}