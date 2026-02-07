import 'package:drahkma/core/domain/entities/use_cases.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_controller.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_state.dart';
import 'package:drahkma/features/auth/presentation/forms/auth_form.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final UseCases useCases;
  final AuthController controller;
  const AuthPage(this.controller, this.useCases, {super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.checkSession();
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _login.dispose();
    _password.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
                  child: ValueListenableBuilder<AuthState>(
                    valueListenable: widget.controller,
                    builder: (context, state, _) {
                      if (state is AuthSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'dashboard', (_) => true);
                          }
                        });
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        var value = await widget.useCases.call();

                        _login.text = value;
                      });

                      return Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 80,
                              minHeight: 80,
                              maxWidth: 300,
                              maxHeight: 300,
                            ),
                            child: AspectRatio(
                              aspectRatio: 0.95,
                              child: Image.asset(
                                "images/logo_yellow.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          AuthForm(
                            widget.controller,
                            constraints,
                            _login,
                            _password,
                            loginFocusNode: _loginFocusNode,
                            passwordFocusNode: _passwordFocusNode,
                          )
                        ],
                      );
                    },
                  ),
                )));
  }
}
