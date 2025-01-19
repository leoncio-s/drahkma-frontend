import 'package:drahkma/Auth/auth_dto.dart';
import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/commonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  bool notShowPassword = true;
  LoginPage({super.key});
  @override
  State<StatefulWidget> createState() => _loginPage();
}

class _loginPage extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500, minWidth: 200),
              child: Center(
                  child: _containerBorder(
                      child: Column(
                children: [
                  _image(),
                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        children: [
                          _emailField(),
                          const SizedBox(
                            height: 30,
                          ),
                          _passwordField(),
                          _forgetPasswordButton(),
                          _loginButton(),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 60,
                              child: const Align(
                                alignment: Alignment.center,
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              )),
                          _registerButton()
                        ],
                      ))
                ],
              ))),
            ),
          ),
        ),
      ),
      extendBody: true,
    );
  }

  _containerBorder({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          // border: MediaQuery.of(context).size.width > 500
          //     ? Border.all(width: 2.0, color: Colors.white)
          //     : null,
          borderRadius: BorderRadius.circular(20.0)),
      child: child,
    );
  }

  _image() {
    return Image.asset(
      "images/logo_yellow.png",
      width: 250,
      height: 250,
    );
  }

  _emailField() {
    return TextFormFieldComponent(
        controller: _email,
        labelText: "E-mail",
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          var validate = AuthDto.validateEmail(value);
          if (validate is Map) {
            return validate['error'];
          }
          return null;
        });
  }

  _passwordField() {
    return TextFormFieldComponent(
      controller: _password,
      labelText: "Senha",
      obscureText: widget.notShowPassword,
      obscuringCharacter: "*",
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          suffixIcon: IconButton.outlined(
              splashRadius: 0.1,
              enableFeedback: true,
              isSelected: false,
              onPressed: () {
                setState(() {
                  widget.notShowPassword = !widget.notShowPassword;
                });
              },
              icon: Icon(widget.notShowPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined))),
      validator: (value) {
        if (value != null && (value.length < 8 || value.length > 20)) {
          return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
        }
        return null;
      },
    );
  }

  _forgetPasswordButton() {
    return SizedBox(
        height: 60,
        width: double.maxFinite,
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              child: const Text(
                "Esqueceu a senha?",
                textAlign: TextAlign.end,
              ),
              onPressed: () {}),
        ));
  }

  _loginButton() {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        child: const Text("Login"),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              var ret = await AuthService.login(_email.text, _password.text);
              if (ret is UserDto) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacementNamed("/dashboard");
              } else {
                final snackBar = SnackBar(
                  content: Text(ret['errors'] ?? "Problema para efetuar login, tente novamente!"),
                  backgroundColor: Colors.red,
                  elevation: 10.0,
                  showCloseIcon: true,
                  // ignore: use_build_context_synchronously
                  closeIconColor:
                      // ignore: use_build_context_synchronously
                      Theme.of(context).primaryColor,
                  duration: const Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating,
                  dismissDirection: DismissDirection.startToEnd,
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

            } on Exception catch (e) {
              debugPrint(e.toString());
              final snackBar = SnackBar(
                content: const Text("Erro interno no servidor. Tente novamente!"),
                backgroundColor: Colors.red,
                elevation: 10.0,
                showCloseIcon: true,
                // ignore: use_build_context_synchronously
                closeIconColor:
                    // ignore: use_build_context_synchronously
                    Theme.of(context).primaryColor,
                duration: const Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.startToEnd,
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
      ),
    );
  }

  _registerButton() {
    return SizedBox(
      // width: double.maxFinite,
      child: TextButton(
        onHover: (value) {},
        onPressed: () {
          Navigator.maybeOf(context)!.pushNamed("/register");
        },
        child: const Text(
          "Criar Conta",
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
