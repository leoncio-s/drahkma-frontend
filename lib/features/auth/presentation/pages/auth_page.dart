import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
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

  AppState? _lastProcessedStateType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.controller.checkSession();
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

  void _handleStateChange(AppState state) {
    if (state is AuthSuccess && _lastProcessedStateType is! AuthSuccess) {
      _lastProcessedStateType = state;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context)
              .pushReplacementNamed('dashboard');
        }
      });
    } else if (state is NoNetworkState && _lastProcessedStateType is! NoNetworkState) {
      _lastProcessedStateType = state;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushNamed('/');
        }
      });
    } else if (state is TimeoutConnectState && _lastProcessedStateType is! TimeoutConnectState) {
      _lastProcessedStateType = state;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
              backgroundColor: AppColors.redError,
              content:
                  Text("Timeout na conexão com o servidor. Tente novamente."),
              actions: [
                TextButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .hideCurrentMaterialBanner(),
                    child: Text("OK"))
              ]));
        }
      });
      widget.controller.value = AuthInitial();
    } else if (state is ErrorState && _lastProcessedStateType is! ErrorState) {
      _lastProcessedStateType = state;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
              backgroundColor: AppColors.redError,
              content: Text(state.message ??
                  "Ocorreu um erro com a solicitação. Tente novamente mais tarde!"),
              actions: [
                TextButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .hideCurrentMaterialBanner(),
                    child: Text("OK"))
              ]));
        }
      });
      widget.controller.value = AuthInitial();
    }else if(state is AuthInitial){
      _lastProcessedStateType = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
                  child: ValueListenableBuilder<AppState>(
                    valueListenable: widget.controller,
                    builder: (context, state, _) {

                      Future.microtask(()=> _handleStateChange(state));

                      if(state is AuthInitial && _login.text.isEmpty)
                      {

                        Future.microtask(() async {
                          String? value = await widget.useCases.call() as String?;
                          if(mounted && _login.text.isEmpty){
                              _login.text = value ?? "";
                          }
                        });

                      }

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
