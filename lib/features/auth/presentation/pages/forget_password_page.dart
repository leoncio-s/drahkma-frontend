import 'dart:developer';
import 'package:drahkma/core/utils/extensions/string_regex_validate.dart';
import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/auth/data/source/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/presentation/views/forget_password_code_view.dart';
import 'package:drahkma/core/presentation/dialogs/modal_dialog.dart';
import 'package:drahkma/core/presentation/widgets/default_layout_widget.dart';
import 'package:drahkma/core/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/core/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/core/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
      getIt<AuthLocalDatasource>().getStorageEmail().then((value){
        _email.text = value ?? '';
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DefaultLayoutWidget(child: _form(),),
    );

  Widget _form(){
    return Form(
      key: _formState,
      child: Column(
        children: [
          Title(color: Theme.of(context).primaryColor, child: Text("Esqueceu a senha?", textScaler: TextScaler.linear(principalCardScaller(MediaQuery.of(context).size.width)),)),
          const SizedBox(height: 50,),
          TextFormFieldWidget(
            labelText: "E-mail",
            controller: _email,
            validator: (value){
              if(value.isSqlInjection) {
                return "E-mail inválido";
              }
              return null;
            },
            ),
          const SizedBox(height: 30,),
          ElevatedButtonWidget(title: "Redefinir Senha", onPressed: () async {
            if(_formState.currentState!.validate()){
              final closeModal = modalDialog(context, "loading");
              late SnackBar snack;
              try{
                var ret = await getIt<AuthRemoteDatasource>().forgetPassword(_email.text);

                
                if(!mounted) return;

                if(ret!['message'] != null) {
                  snack = SnackBarWidget(content: Text(ret['message']), backgroundColor: Colors.white, closeIconColor: Colors.black,);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgetPasswordCodeView(email: _email.text)));
                } else {
                  snack = SnackBarWidget(content: ret['errors']);
                }

                ScaffoldMessenger.of(context).showSnackBar(snack);
              }on ArgumentError catch(ex)
              {
                snack = SnackBarWidget(content: ex.message);
                ScaffoldMessenger.of(context).showSnackBar(snack);
              }on ClientException{
                snack = SnackBarWidget(content: Text("Erro interno no servidor"));
                ScaffoldMessenger.of(context).showSnackBar(snack);
              }on Exception catch(e, s){
                snack = SnackBarWidget(content: Text("Erro interno no servidor"));
                ScaffoldMessenger.of(context).showSnackBar(snack);
                log(e.toString(), level: 1, stackTrace: s, name: "Exception Forget password page");
              }finally
              {
                closeModal();
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

                Navigator.of(context).pushNamed("login");
              }),
        ))
        ],
      )
      );
  }
}