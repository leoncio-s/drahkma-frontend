import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/Utils/string_regex_validate.dart';
import 'package:drahkma/Utils/text_scaler.dart';
import 'package:drahkma/commonsComponents/default_layout.dart';
import 'package:drahkma/commonsComponents/elevated_button_component.dart';
import 'package:drahkma/commonsComponents/snackbar_component.dart';
import 'package:drahkma/commonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget{
  final String? email;
  const ForgetPasswordPage({super.key, this.email});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController _email = TextEditingController();

  @override
  void initState() {
    if(widget.email != null) _email.text = widget.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DefaultLayout(child: _form(),),
    );

  _form(){
    return Form(
      key: _formState,
      child: Column(
        children: [
          Title(color: Theme.of(context).primaryColor, child: Text("Esqueceu a senha?", textScaler: TextScaler.linear(principalCardScaller(MediaQuery.of(context).size.width)),)),
          const SizedBox(height: 50,),
          TextFormFieldComponent(
            labelText: "E-mail",
            controller: _email,
            validator: (value){
              if(StringValidators.sqlInjection(value)) {
                return "E-mail inválido";
              }
            },
            ),
          const SizedBox(height: 30,),
          ElevatedButtonComponent(title: "Redefinir Senha", onPressed: () async {
            if(_formState.currentState!.validate()){
              try{
                var ret = await AuthService.forgetPassword(_email.text);
                var snack;

                if(ret['message'] != null) {
                  snack = SnackBarComponent(content: Text(ret['message']), backgroundColor: Colors.white, closeIconColor: Colors.black,);
                } else {
                  snack = SnackBarComponent(content: ret['message']);
                }

                ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
              }on Exception catch(ex){
                var  snack = SnackBarComponent(content: Text(ex.toString()));
                ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
              }
            }
          }),

          const SizedBox(
            height: 30,
          ),

          SizedBox(
        height: 60,
        width: double.maxFinite,
        child: Align(
          alignment: Alignment.center,
          child: TextButton(
              child: const Text(
                "Página de Login",
                textAlign: TextAlign.end,
              ),
              onPressed: () {

                Navigator.of(context).pushNamed("/auth/login");
              }),
        ))
        ],
      )
      );
  }
}