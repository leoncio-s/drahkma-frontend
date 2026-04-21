
import 'package:drahkma/core/error/unauthenticated_exception.dart';
import 'package:drahkma/core/error/update_password_exception.dart';
import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/user/domain/usecases/user_update_password.dart';
import 'package:drahkma/core/presentation/widgets/default_layout_widget.dart';
import 'package:drahkma/core/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/core/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/core/presentation/widgets/text_form_field_widget.dart';
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
      SnackBarWidget? snack;
      try{
        await getIt<UserUpdatePassword>().call(currentPassword: _curPasswd.text, newPassword:  _newPasswd.text, confirmNewPassword: _confNewPasswd.text);
        
        snack = SnackBarWidget(content: Text("Senha alterada com sucesso"), backgroundColor: Colors.green, duration: Duration(seconds: 3),);
        Future.delayed(Duration(seconds: 3), (){
          mounted ? Navigator.of(context).pop() : null;
        });
      }on UnauthenticatedException
      {
        snack = SnackBarWidget(content: Text("Usuário Não autenticado"), backgroundColor: Colors.redAccent, duration: Duration(seconds: 3),);
        if(mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }on UpdatePasswordException catch (e)
      {
        snack = SnackBarWidget(content: Text(e.message), backgroundColor: Colors.red, duration: Duration(seconds: 3),);
      }finally
      {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
      }

    }
    return;
  }
}