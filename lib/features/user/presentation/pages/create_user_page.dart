
import 'dart:convert';

import 'package:drahkma/core/utils/text_scaler.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/models/auth_model.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/usecases/user_register.dart';
import 'package:drahkma/presentation/widgets/default_layout_widget.dart';
import 'package:drahkma/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  bool notShowPassword = true;
  bool notShowPassword2 = true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController =
      MaskedTextController(mask: "(00) 0 0000-0000");
  late Map? errors;

  @override
  void initState() {
    errors = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DefaultLayoutWidget(
        child: _form(),
      );

  Widget _form() => _containerBorder(
          child: Form(
        key: _formKey,
        // autovalidateMode: AutovalidateMode.onUnfocus,
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
        labelText: "Nome Completo",
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
      labelText: "E-mail",
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
        labelText: "Senha",
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
        labelText: "Confirme a Senha",
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
        labelText: "Número de Telefone",
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
        // width: double.maxFinite,
        child: TextButton.icon(
          icon: const Icon(Icons.login),
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((state) {
            if (state.contains(WidgetState.hovered)) {
              return Theme.of(context).colorScheme.secondary;
            }
            return null;
          })),
          onPressed: () {
            Navigator.maybeOf(context)!.pushReplacementNamed("/auth/login");
          },
          label: const Text(
            "Ir para página de login",
            textAlign: TextAlign.right,
            style: TextStyle(decorationThickness: 5.0),
          ),
        ),
      );

  void _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      try{
        var phoneNumber = _phoneNumberController.text.replaceAll(RegExp(r"[\(\)\s)-]+"), "");
        UserDTO user = UserDTO(
          fullname: _fullNameController.text,
          email: _emailController.text,
          phoneNumber: phoneNumber,
          password: _passwordController.text, 
          confirmNewPassword: _confPasswordController.text
        );

        dynamic ret = await getIt<UserRegister>().call(user: user);

        if (ret.runtimeType == UserModel) {
          if(mounted)  Navigator.maybeOf(context)?.pushReplacement(MaterialPageRoute(builder: (context) => const SuccessPage()),);
        } else {
          setState(() {
            errors = ret['errors'] ?? ret;
          });
        }
        
      }on ArgumentError catch(e)
      {
        Map<String, dynamic> json = jsonDecode(e.message);
        setState(() {
          errors=json['errors'];
        });
        return;
      }on Exception
      {
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
              ? Text(entry.value.toString(), style: errorStyle, textAlign: textAlignError,)
              : Text("${entry.key} : ${ (entry.value.runtimeType == List) ? (entry.value as List).map<String>((el)=> el.toString()).toString() : entry.value.toString()}",
                  style: errorStyle, textAlign: textAlignError)
          ).toList();

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
  const SuccessPage({super.key});

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
                icon: const Icon(Icons.login),
                style: ButtonStyle(backgroundColor:
                    WidgetStateProperty.resolveWith<Color?>((state) {
                  if (state.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.secondary;
                  }
                  return null;
                })),
                onPressed: () {
                  Navigator.maybeOf(context)!
                      .pushReplacementNamed("/auth/login");
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
