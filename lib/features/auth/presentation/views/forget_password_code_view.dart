import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource_impl.dart';
import 'package:drahkma/core/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/core/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/core/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';

class ForgetPasswordCodeView extends StatefulWidget {
  final String email;
  const ForgetPasswordCodeView({super.key, required this.email});

  @override
  State<ForgetPasswordCodeView> createState() => ForgetPasswordCodeViewState();
}

class ForgetPasswordCodeViewState extends State<ForgetPasswordCodeView> {
  bool notShowPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    notShowPassword = true;
    email.text = widget.email;
  }

  @override
  void dispose() {
    loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsetsGeometry.all(15.0),
              child: _form(),
            ),
          ),
        ),
      );

  Widget _form() {
    return Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Defina a nova senha",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0),
                textScaler: TextScaler.linear(1.2),
              ),
              TextFormFieldWidget(
                hintText: 'E-mail',
                controller: email,
                readOnly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormFieldWidget(
                hintText: 'Código',
                controller: code,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 6,
                validator: (value) {
                  if (value != null && (value.length < 6 || value.length > 6)) {
                    return "Código Inválido";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _passwordField("Senha", password),
              const SizedBox(
                height: 20,
              ),
              _passwordField('Confirmação de Senha', confPassword),
              const SizedBox(
                height: 20,
              ),
              ElevatedButtonWidget(
                  readOnly: loading,
                  icon: loading ? CircularProgressIndicator() : null,
                  title: !loading ? "Alterar Senha" : "",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = !loading;
                      });
                      try {
                        AuthRemoteDatasourceImpl dataSource =
                            getIt<AuthRemoteDatasource>()
                                as AuthRemoteDatasourceImpl;
                        var ret = await dataSource.forgetPasswordCode(
                            email.text,
                            code.text,
                            password.value.text,
                            confPassword.value.text);
                        if (!mounted) return;
                        if (ret['message'] != null) {
                          SnackBar snackBar = SnackBarWidget(
                              content: Text(ret['message']),
                              backgroundColor: Colors.green[600]!);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pushReplacementNamed('login');
                        } else {
                          SnackBar snackBar =
                              SnackBarWidget(content: Text(ret['error']));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } on Exception catch (ex) {
                        SnackBar snackBar =
                            SnackBarWidget(content: Text(ex.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } finally {
                        setState(() {
                          loading = !loading;
                        });
                      }
                    }
                  }),
              SizedBox(
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
                        Navigator.of(context).pushNamed(AppRoutes.login);
                      }),
                ))
            ],
          ),
        ));
  }

  Widget _passwordField(String label, TextEditingController controller) {
    return TextFormFieldWidget(
        maxLength: 20,
        hintText: label,
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
          } else {
            setState(() {
              controller.text = value!;
            });
          }
          return null;
        });
  }
}
