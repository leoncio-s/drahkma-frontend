import 'package:flutter/material.dart';
import 'package:drahkma/Auth/auth_dto.dart';
import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/commonsComponents/input_text_style.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<StatefulWidget> createState() => AuthState();
}

class AuthState extends State<Auth> {
  AuthState();

  final ScrollController _scrollController = ScrollController();

  @override
  void setState(VoidCallback fn) {
    // _loginForm(context);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
            child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: 500,
                          maxHeight: 600,
                          minHeight: 300,
                          minWidth: 100),
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            border:
                                Border.all(color: Colors.white, width: 2.0)),
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "LFINANCA",
                                textScaler: TextScaler.linear(1.1),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              _loginForm(context)
                            ],
                          ),
                        ),
                      )),
                ))));
  }

  Widget _loginForm(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    bool clicked = false;

    return SafeArea(
        maintainBottomViewPadding: true,
        minimum: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //// email field
                TextFormField(
                  controller: email,
                  showCursor: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.dark,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          required maxLength}) =>
                      null,
                  maxLength: 150,
                  maxLines: 1,
                  autofocus: true,
                  enableInteractiveSelection: true,
                  decoration: const InputDecoration(
                      constraints: BoxConstraints(maxWidth: 400, minHeight: 10),
                      labelText: "E-mail"),
                  style: inputTextStyle(),
                  validator: (value) {
                    var validate = AuthDto.validateEmail(value);
                    if (validate is Map) {
                      return validate['error'];
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                /// password
                TextFormField(
                  controller: password,
                  cursorColor: Colors.black,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          required maxLength}) =>
                      null,
                  maxLength: 20,
                  maxLines: 1,
                  enableInteractiveSelection: true,
                  decoration: const InputDecoration(
                      constraints: BoxConstraints(maxWidth: 400, minHeight: 10),
                      labelText: "Senha"),
                  style: inputTextStyle(),
                  obscureText: true,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value != null &&
                        (value.length < 8 || value.length > 20)) {
                      return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),

                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 60,
                      maxWidth: 400,
                      minHeight: 15,
                      maxHeight: 50),
                  child: SizedBox(
                      width: double.infinity,
                      height: double.maxFinite,
                      child: clicked == true
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    clicked = true;
                                  });
                                  try {
                                    var ret = await AuthService.login(
                                        email.text, password.text);
                                    if (ret is UserDto) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context)
                                          .pushReplacementNamed("/dashboard");
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(ret['errors']),
                                        backgroundColor: Colors.red,
                                        elevation: 10.0,
                                        showCloseIcon: true,
                                        // ignore: use_build_context_synchronously
                                        closeIconColor:
                                            // ignore: use_build_context_synchronously
                                            Theme.of(context).primaryColor,
                                        duration: const Duration(seconds: 5),
                                        behavior: SnackBarBehavior.floating,
                                        dismissDirection:
                                            DismissDirection.startToEnd,
                                      );
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }

                                    setState(() {
                                      clicked = false;
                                    });
                                  } on Exception catch (e) {
                                    // debugPrint(e.toString());
                                    final snackBar = SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                      elevation: 10.0,
                                      showCloseIcon: true,
                                      // ignore: use_build_context_synchronously
                                      closeIconColor:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context).primaryColor,
                                      duration: const Duration(seconds: 5),
                                      behavior: SnackBarBehavior.floating,
                                      dismissDirection:
                                          DismissDirection.startToEnd,
                                    );
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    setState(() {
                                      clicked = false;
                                    });
                                  }
                                }
                              },
                              child: const Text("Login"))),
                ),
                


                // esqueceu a senha
                // Align(
                //   widthFactor: 3,
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     style: ButtonStyle(
                //         overlayColor: null,
                //         shadowColor: null,
                //         foregroundColor:
                //             WidgetStateProperty.resolveWith<Color?>(
                //                 (Set<WidgetState> state) {
                //           if (state.contains(WidgetState.hovered)) {
                //             return Colors.lightBlue;
                //           }
                //           return Colors.white;
                //         })),
                //     child: const Text(
                //       "Esqueceu a senha?",
                //       textAlign: TextAlign.start,
                //     ),
                //   ),
                // ),
              ]),
        ));
  }
}
