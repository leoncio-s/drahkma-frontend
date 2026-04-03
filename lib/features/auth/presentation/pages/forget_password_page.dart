import 'dart:developer';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/core/utils/extensions/string_regex_validate.dart';
import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/presentation/views/forget_password_code_view.dart';
import 'package:drahkma/core/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/core/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/core/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ForgetPasswordPage extends StatefulWidget {
  final String? email;
  const ForgetPasswordPage({super.key, this.email});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _email = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    if (widget.email != null) {
      _email.text = widget.email!;
    } else {
      if(mounted){
        getIt<AuthLocalDatasource>().getStorageEmail().then((value) {
        _email.text = value ?? '';
      });
      }
    }
    super.initState();
  }
  
  @override 
  dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 600, minHeight: double.maxFinite),
            child: _form(),
          ),
        ),
      );

  Widget _form() {
    return Form(
        key: _formState,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Title(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Esqueceu a senha?",
                  textScaler: TextScaler.linear(
                      principalCardScaller(MediaQuery.of(context).size.width)),
                )),
            const SizedBox(
              height: 50,
            ),
            TextFormFieldWidget(
              hintText: "E-mail",
              controller: _email,
              validator: (value) {
                if (value.isSqlInjection) {
                  return "E-mail inválido";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButtonWidget(
                title: !loading ? "Redefinir Senha" : "",
                icon: loading ? CircularProgressIndicator() : null,
                foregroundHoverColor: AppColors.blueNavy,
                readOnly: loading,
                onPressed: () async {
                  setState(() {
                      loading = !loading;
                  });
                  if (_formState.currentState!.validate()) {
                    late SnackBar snack;
                    try {
                      var ret = await getIt<AuthRemoteDatasource>()
                          .forgetPassword(_email.text);

                      if (!mounted) return;

                      if (ret != null && ret['message'] != null) {
                        snack = SnackBarWidget(
                          content: Text(ret['message']),
                          backgroundColor: Colors.white,
                          closeIconColor: Colors.black,
                        );
                        if(mounted)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(snack);
                          // closeModal();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                ForgetPasswordCodeView(email: _email.text)));
                        }
                        // ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      } else {
                        snack = SnackBarWidget(content: Text(ret?['errors'] ?? "Erro Desconhecido"));
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                      
                    } on ArgumentError catch (ex) {
                      snack = SnackBarWidget(content: Text(ex.message));
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } on ClientException {
                      snack = SnackBarWidget(
                          content: Text("Erro interno no servidor"));
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } on Exception catch (e, s) {
                      snack = SnackBarWidget(
                          content: Text("Erro interno no servidor"));
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                      log(e.toString(),
                          level: 1,
                          stackTrace: s,
                          name: "Exception Forget password page");
                    } finally {
                      setState(() {
                        loading = !loading;
                      });
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
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.fromMap({
                            WidgetState.hovered: AppColors.blueNavy,
                            WidgetState.any: Colors.transparent
                          }),
                          foregroundColor: WidgetStateProperty.fromMap(
                              {WidgetState.any: Colors.white})),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5,),
                          Text(
                        "Voltar a página de Login",
                        textAlign: TextAlign.end,
                      )
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("login");
                      }),
                ))
          ],
        ));
  }
}
