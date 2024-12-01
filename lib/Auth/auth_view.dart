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
                          // maxHeight: 600,
                          minHeight: 300,
                          minWidth: 100),
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            border: MediaQuery.of(context).size.width > 600
                                ? Border.all(color: Colors.white, width: 2.0)
                                : null),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage("images/logo_yellow.png"),
                                width: 230,
                                height: 230,
                                fit: BoxFit.cover,
                                errorBuilder: (context, obj, trace) {
                                  return const Text("DRAHKMA");
                                },
                              ),
                              const SizedBox(
                                height: 30.0,
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
        maintainBottomViewPadding: false,
        bottom: false,
        minimum: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //// email field
                TextFormField(
                    controller: email,
                    showCursor: true,
                    cursorColor: Colors.white,
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
                    decoration: (const InputDecoration())
                        .applyDefaults(Theme.of(context).inputDecorationTheme)
                        .copyWith(
                          contentPadding: const EdgeInsets.all(10.0),
                          hintText: "Email",
                          labelText: "Email"
                        )
                        ,
                    style: inputTextStyle(),
                    validator: (value) {
                      var validate = AuthDto.validateEmail(value);
                      if (validate is Map) {
                        return validate['error'];
                      }
                      return null;
                    },
                  // ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// password
                TextFormField(
                  controller: password,
                  cursorColor: Colors.white,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          required maxLength}) =>
                      null,
                  maxLength: 20,
                  maxLines: 1,
                  enableInteractiveSelection: false,
                  decoration: (const InputDecoration()).applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
                    hintText: "Senha",
                    labelText: "Senha",
                    contentPadding: const EdgeInsets.all(10.0)
                  ),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){}, child: const Text("Esqueceu a senha?",))
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 60,
                      // maxWidth: 400,
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

                const SizedBox(
                  height: 40.0,
                ),

                
                ConstrainedBox(constraints: const BoxConstraints(
                  minWidth: 200, maxWidth: 300, minHeight: 2, maxHeight: 5),
                  child: const Divider(
                  height: 10.0,
                  color: Colors.white,
                ),
                ),

                const SizedBox(
                  height: 30.0,
                ),

                TextButton(onPressed: (){}, child: const Text("Criar Conta"))
              ]),
        ));
  }
}
