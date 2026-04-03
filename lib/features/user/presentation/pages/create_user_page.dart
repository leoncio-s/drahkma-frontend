import 'dart:convert';

import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/features/auth/data/models/auth_model.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/core/presentation/widgets/default_layout_widget.dart';
import 'package:drahkma/core/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/core/presentation/widgets/text_form_field_widget.dart';
import 'package:drahkma/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CreateUserPage extends StatefulWidget {
  final UserController userController;
  const CreateUserPage(this.userController, {super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  bool notShowPassword = true;
  bool notShowPassword2 = true;
  late CreateUserController controller;
  _CreateUserPageState();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController =
      MaskedTextController(mask: "(00) 0 0000-0000");
  late Map? errors;
  final ButtonStyle _textButtonStyle = ButtonStyle(
      backgroundColor:
          WidgetStateProperty.fromMap({WidgetState.hovered: AppColors.gold}),
      foregroundColor:
          WidgetStateColor.fromMap({WidgetState.any: Colors.white}));

  @override
  void initState() {
    errors = null;
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(
            builder: (ctx, constraints) => SingleChildScrollView(
                    child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (ctx, state, child) {
                    return child!;
                  },
                  child: Center(
                    widthFactor: 90,
                    child: Container(
                      constraints: constraints
                          .widthConstraints()
                          .copyWith(maxWidth: 600),
                      child: _form(),
                    ),
                  ),
                ))),
      );

  Widget _form() => _containerBorder(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Cadastre-se",
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(
                  principalCardScaller(MediaQuery.of(context).size.width)),
            ),
            const SizedBox(
              height: 15,
            ),
            _fullNameField(),
            const SizedBox(
              height: 15,
            ),
            _emailField(),
            const SizedBox(
              height: 15,
            ),
            _phoneNumberField(),
            const SizedBox(
              height: 15,
            ),
            _passwordField(),
            const SizedBox(
              height: 15,
            ),
            _confPasswordField(),
            const SizedBox(
              height: 15,
            ),
            _errors(),
            ElevatedButtonWidget(title: "Cadastrar", onPressed: _formSubmit),
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
            _signinButton()
          ],
        ),
      ));

  Container _containerBorder({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: child,
    );
  }

  TextFormFieldWidget _fullNameField() => TextFormFieldWidget(
        controller: _fullNameController,
        hintText: "Nome Completo",
        autovalidateMode: AutovalidateMode.onUnfocus,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          } else if (value.length < 3 || value.length > 100) {
            return "O tamanho minímo para o campo é 3 e o máximo é 100";
          }
          return null;
        },
      );

  TextFormFieldWidget _emailField() => TextFormFieldWidget(
      controller: _emailController,
      hintText: "E-mail",
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo Obrigatório";
        }
        var validate = AuthModel.validateEmail(value);
        if (validate is Map) {
          return validate['error'];
        }
        return null;
      });

  TextFormFieldWidget _passwordField() => TextFormFieldWidget(
        controller: _passwordController,
        hintText: "Senha",
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
          }
          return null;
        },
      );

  TextFormFieldWidget _confPasswordField() => TextFormFieldWidget(
        controller: _confPasswordController,
        hintText: "Confirme a Senha",
        obscureText: notShowPassword2,
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
                    notShowPassword2 = !notShowPassword2;
                  });
                },
                icon: Icon(notShowPassword2
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined))),
        validator: (value) {
          if (value != null && (value.length < 8 || value.length > 20)) {
            return "Tamanho mínimo é 8 e o máximo é 20 para a senha";
          } else if (value != _passwordController.text) {
            return "Senhas não conferem";
          }
          return null;
        },
      );

  TextFormFieldWidget _phoneNumberField() => TextFormFieldWidget(
        controller: _phoneNumberController,
        hintText: "Número de Telefone",
        keyboardType: TextInputType.phone,
        // keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUnfocus,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo Obrigatório";
          }
          return null;
        },
      );

  SizedBox _signinButton() => SizedBox(
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
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Voltar a página de Login",
                  textAlign: TextAlign.end,
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("login");
            }),
      ));

  void _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        var phoneNumber =
            _phoneNumberController.text.replaceAll(RegExp(r"[\(\)\s)-]+"), "");
        UserDTO user = UserDTO(
            fullname: _fullNameController.text,
            email: _emailController.text,
            phoneNumber: phoneNumber,
            password: _passwordController.text,
            confirmNewPassword: _confPasswordController.text);

        await widget.userController.registerUser(user);
        
        var state = widget.userController.value;
        if (state is ErrorState) {
          setState(() {
            errors = {'error': state.message};
          });
        } else if (mounted) {
          Navigator.maybeOf(context)?.pushReplacement(
            MaterialPageRoute(builder: (context) => SuccessPage()),
          );
        }
      } on ArgumentError catch (e) {
        Map<String, dynamic> json = jsonDecode(e.message);
        setState(() {
          errors = json['errors'];
        });
        return;
      } on Exception {
        rethrow;
      }
    }
  }

  RenderObjectWidget _errors() {
    TextStyle errorStyle = const TextStyle(
        color: Colors.red,
        height: 2,
        leadingDistribution: TextLeadingDistribution.proportional);

    TextAlign textAlignError = TextAlign.left;

    if (errors != null) {
      List<Widget>? elements = errors!.entries
          .map<Widget>((entry) => entry.key.toString().contains("errors")
              ? Text(
                  entry.value.toString(),
                  style: errorStyle,
                  textAlign: textAlignError,
                )
              : Text(
                  "${entry.key} : ${(entry.value.runtimeType == List) ? (entry.value as List).map<String>((el) => el.toString()).toString() : entry.value.toString()}",
                  style: errorStyle,
                  textAlign: textAlignError))
          .toList();

      elements.add(const SizedBox(
        height: 5,
      ));
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: elements,
      );
    }
    return const SizedBox();
  }
}

class SuccessPage extends StatelessWidget {
  final ButtonStyle _textButtonStyle = ButtonStyle(
      backgroundColor:
          WidgetStateProperty.fromMap({WidgetState.hovered: AppColors.gold}),
      foregroundColor:
          WidgetStateColor.fromMap({WidgetState.any: Colors.white}));
  SuccessPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultLayoutWidget(
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              weight: 900,
              size: 150,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Primeiro passo concluído!",
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(
                  principalCardScaller(MediaQuery.of(context).size.width)),
            ),
            Text(
              "Enviamos um e-mail para validação do cadastro, verifique!",
              style: const TextStyle(
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(principalCardScaller(
                  MediaQuery.of(context).size.width -
                      (MediaQuery.of(context).size.width * 0.1))),
            ),
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
            SizedBox(
              // width: double.maxFinite,
              child: TextButton.icon(
                icon: const Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                style: _textButtonStyle,
                onPressed: () {
                  Navigator.maybeOf(context)!.pushReplacementNamed("login");
                },
                label: const Text(
                  "Ir para página de login",
                  textAlign: TextAlign.right,
                  style: TextStyle(decorationThickness: 5.0),
                ),
              ),
            )
          ],
        ),
      );
}
