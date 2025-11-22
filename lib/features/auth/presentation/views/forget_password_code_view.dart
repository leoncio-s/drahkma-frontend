import 'package:drahkma/Services/auth_service.dart';
import 'package:drahkma/presentation/dialogs/modalDialog.dart';
import 'package:drahkma/presentation/widgets/default_layout_widget.dart';
import 'package:drahkma/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';

class ForgetPasswordCodeView extends StatefulWidget{
  final String email;
  const ForgetPasswordCodeView({super.key, required this.email});
  
  @override
  State<ForgetPasswordCodeView> createState()=>ForgetPasswordCodeViewState();
}

class ForgetPasswordCodeViewState extends State<ForgetPasswordCodeView>{
  bool notShowPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
    notShowPassword = true;
    email.text = widget.email;
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: DefaultLayoutWidget(child: _form(),),);


  Widget _form(){

    return Form(
      key: _formKey,
      child: Column(
      children: [
        TextFormFieldWidget(labelText: 'E-mail', controller: email, readOnly: true,),
        const SizedBox(height: 20,),
        TextFormFieldWidget(labelText:'Código', controller: code, autovalidateMode: AutovalidateMode.onUserInteraction, maxLength: 6, validator: (value){
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
        ElevatedButtonWidget(title: "Alterar Senha", onPressed: ()async{
          if(_formKey.currentState!.validate()){
            var closeModal = modalDialog(context, "loading", barrierDismissible: false);
            // showDialog(context: context, builder: showModal);
            try{
              var ret = await AuthService.forgetPasswordCode(email.text, code.text, password.value.text, confPassword.value.text);
              closeModal();
              if(!mounted) return;
              if(ret['message'] != null)
              {
                SnackBar snackBar= SnackBarWidget(content: Text(ret['message']), backgroundColor: Colors.green[600]!);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pushReplacementNamed('/auth/login');
              }else{
                SnackBar snackBar = SnackBarWidget(content: Text(ret['error']));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }on Exception catch(ex){
              closeModal();
              SnackBar snackBar = SnackBarWidget(content: Text(ex.toString()));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        })
      ],
    ));
  }

  Widget _passwordField(String label, TextEditingController controller){
    return TextFormFieldWidget(
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