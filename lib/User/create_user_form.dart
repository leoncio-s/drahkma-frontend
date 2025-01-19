import 'package:drahkma/Auth/auth_dto.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:drahkma/Utils/text_scaler.dart';
import 'package:drahkma/commonsComponents/default_layout.dart';
import 'package:drahkma/commonsComponents/elevated_button_component.dart';
import 'package:drahkma/commonsComponents/text_form_field_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  bool notShowPassword = true;
  bool notShowPassword2 = true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController =
      MaskedTextController(mask: "(00) 0 0000-0000");
  Map? errors = null;

  @override
  Widget build(BuildContext context) => DefaultLayout(
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
            ElevatedButtonComponent(title: "Cadastrar", onPressed: _formSubmit),
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

  _containerBorder({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: child,
    );
  }

  _fullNameField() => TextFormFieldComponent(
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

  _emailField() => TextFormFieldComponent(
      controller: _emailController,
      labelText: "E-mail",
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo Obrigatório";
        }
        var validate = AuthDto.validateEmail(value);
        if (validate is Map) {
          return validate['error'];
        }
        return null;
      });

  _passwordField() => TextFormFieldComponent(
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

  _confPasswordField() => TextFormFieldComponent(
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

  _phoneNumberField() => TextFormFieldComponent(
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

  _signinButton() => SizedBox(
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

  _formSubmit() async {
    Map<String, String> user = {};
    if (_formKey.currentState!.validate()) {
      var phoneNumber = _phoneNumberController.text.replaceAll(RegExp(r"[\(\)\s)-]+"), "");
      user['fullname'] = _fullNameController.text;
      user['email'] = _emailController.text;
      user['password'] = _passwordController.text;
      user['conf_password'] = _confPasswordController.text;
      user['phone_number'] = phoneNumber;

      dynamic ret = await UserService.register(user);

      if (ret.runtimeType == UserDto) {
        context.mounted
            // ignore: use_build_context_synchronously
            ? Navigator.maybeOf(context)?.pushReplacement(
                MaterialPageRoute(builder: (context) => const SuccessPage()),
              )
            : null;
      } else {
        setState(() {
          errors = ret['errors'] ?? ret;
        });
      }
    }
  }

  _errors() {
    TextStyle errorStyle = const TextStyle(
        color: Colors.red,
        height: 2,
        leadingDistribution: TextLeadingDistribution.proportional);

    TextAlign textAlignError = TextAlign.left;

    if (errors != null) {
      List<Widget>? elements = errors!.entries
          .map<Widget>((entry) => entry.key.toString().contains("error")
              ? Text(
                  "${entry.value}",
                  style: errorStyle,
                  textAlign: textAlignError,
                )
              : Text("${entry.key} : ${entry.value.runtimeType == List ? (entry.value as List).map((el)=>el + "\n").toString() : entry.value}",
                  style: errorStyle, textAlign: textAlignError))
          .toList();

      elements.add(const SizedBox(
        height: 5,
      ));
      return Column(
        children: elements,
      );
    }
    return const SizedBox();
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultLayout(
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
