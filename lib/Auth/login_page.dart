import 'package:drahkma/Auth/auth_dto.dart';
import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/CommonsComponents/modal.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:drahkma/commonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  late bool notShowPassword;

  @override
  void initState() {
    super.initState();
    _email.text = AuthService.storageGetEmail() ?? '';
    notShowPassword = true;
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toDashboard(){
    SchedulerBinding.instance.addPostFrameCallback((_){
      if(mounted) Navigator.of(context).pushReplacementNamed("/dashboard");
    });
  }

  Future<UserDto?> _verifyIfUserLogged() async
  {
    Future.delayed(const Duration(milliseconds: 200));
    return await UserService.profile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _verifyIfUserLogged(), builder: (context, snap){
      if(snap.connectionState == ConnectionState.waiting)
      {
        return const Center(child: CircularProgressIndicator(value: 8.0,),);
      }
      
      if(snap.data is UserDto)
      {
        _toDashboard();
        return const Center();
      }

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
    });
  }

  _containerBorder({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
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

  Widget _emailField() {
    return TextFormFieldComponent(
        controller: _email,
        labelText: "E-mail",
        keyboardType: TextInputType.emailAddress,
        focusNode: _emailFocusNode,
        validator: (value) {
          var validate = AuthDto.validateEmail(value);
          if (validate is Map) {
            return validate['error'];
          }
          return null;
        },
        onFieldSubmited: (value){
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        textInputAction: TextInputAction.next,
        );
  }

  Widget _passwordField() {
    return TextFormFieldComponent(
      controller: _password,
      focusNode: _passwordFocusNode,
      labelText: "Senha",
      obscureText: notShowPassword,
      obscuringCharacter: "*",
      keyboardType: TextInputType.visiblePassword,
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
        if (value != null && (value.length < 8 || value.length > 20) || value!.isEmpty) {
          return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
        }
        return null;
      },
      onFieldSubmited: (value){
        _formSubmit();
      },
    );
  }

  Widget _forgetPasswordButton() {
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
              onPressed: () {

                Navigator.of(context).pushNamed("/forget-password");
              }),
        ));
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        onPressed: _formSubmit,
        child: const Text("Login")
      ),
    );
  }

  void _formSubmit() async {
    
          var closeModal = modal(context, "loading");

          if (_formKey.currentState!.validate()) {
            try {
              var ret = await AuthService.login(_email.text, _password.text);

              if(!mounted) return;

              if (ret is UserDto) {
                closeModal();
                _toDashboard();
              } else {
                final snackBar = SnackBar(
                  content: Text(ret['message'] ?? "Problema para efetuar login, tente novamente!"),
                  backgroundColor: Colors.red,
                  elevation: 10.0,
                  showCloseIcon: true,
                  closeIconColor:
                      Theme.of(context).primaryColor,
                  duration: const Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating,
                  dismissDirection: DismissDirection.startToEnd,
                );
                
                closeModal();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

            } on Exception catch (e) {
              debugPrint(e.toString());
              final snackBar = SnackBar(
                content: const Text("Erro interno no servidor. Tente novamente!"),
                backgroundColor: Colors.red,
                elevation: 10.0,
                showCloseIcon: true,
                closeIconColor:
                    Theme.of(context).primaryColor,
                duration: const Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.startToEnd,
              );
              closeModal();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }else{
            closeModal();
            _passwordFocusNode.requestFocus();
          }
  }

  Widget _registerButton() {
    return SizedBox(
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
