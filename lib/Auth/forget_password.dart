import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/Auth/forget_password_codepage.dart';
import 'package:drahkma/Utils/string_regex_validate.dart';
import 'package:drahkma/Utils/text_scaler.dart';
import 'package:drahkma/CommonsComponents/default_layout.dart';
import 'package:drahkma/CommonsComponents/elevated_button_component.dart';
import 'package:drahkma/CommonsComponents/modal.dart';
import 'package:drahkma/CommonsComponents/snackbar_component.dart';
import 'package:drahkma/CommonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget{
  final String? email;
  const ForgetPasswordPage({super.key, this.email});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    if(widget.email != null) {
      _email.text = widget.email!;
    } else {
      _email.text = AuthService.storageGetEmail() ?? '';
    }
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
              return "";
            },
            ),
          const SizedBox(height: 30,),
          ElevatedButtonComponent(title: "Redefinir Senha", onPressed: () async {
            if(_formState.currentState!.validate()){
              final closeModal = modal(context, "loading");
              try{
                var ret = await AuthService.forgetPassword(_email.text);
                late SnackBar snack;
                
                if(!mounted) return;

                if(ret['message'] != null) {
                  closeModal();
                  snack = SnackBarComponent(content: Text(ret['message']), backgroundColor: Colors.white, closeIconColor: Colors.black,);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgetPasswordCodepage(email: _email.text)));
                } else {
                  snack = SnackBarComponent(content: ret['errors']);
                }

                ScaffoldMessenger.of(context).showSnackBar(snack);

              }on Exception catch(ex){
                closeModal();
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