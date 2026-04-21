import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/core/presentation/theme/app_text_styles.dart';
import 'package:drahkma/core/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/core/presentation/widgets/text_form_field_widget.dart';
import 'package:drahkma/core/utils/extensions/string_regex_validate.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_controller.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_state.dart';
import 'package:drahkma/main.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final BoxConstraints constraints;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController loginEDC;
  final TextEditingController passwordEDC;
  final FocusNode? passwordFocusNode;
  final FocusNode? loginFocusNode;

  final AuthController controller;
  AuthForm(this.controller, this.constraints, this.loginEDC, this.passwordEDC,
      {super.key, this.loginFocusNode, this.passwordFocusNode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: 150, maxWidth: 500, minHeight: 200, maxHeight: 450),
        child: Card(
          margin: EdgeInsets.all(5.0),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0.5, strokeAlign: 0.5, color: AppColors.borderBlue),
              borderRadius: BorderRadiusGeometry.circular(30)),
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Form(
                key: _formKey,
                child: AutofillGroup(
                    child: Column(
                  verticalDirection: VerticalDirection.down,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //// field email
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: AppTextStyle.inputTextStyle,
                            ),
                          ],
                        ),
                        TextFormFieldWidget(
                            focusNode: loginFocusNode,
                            controller: loginEDC,
                            prefixIcon: Icon(Icons.email),
                            autofillHints: [AutofillHints.email],
                            readOnly: controller.value is AuthLoading,
                            textInputAction: TextInputAction.next,
                            onFieldSubmited: (_) => passwordFocusNode?.requestFocus(),
                            validator: (value) {
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (value == null || value.isEmpty)
                              {
                                return "Campo obrigatório";
                              }
                              if (!emailRegex.hasMatch(value) ||
                                  value.isSqlInjection) {
                                return "Informe um e-mail valido";
                              }
                              if (value.length < 4) {
                                return "O tamanho minímo do campo é 3 caracteres";
                              }
                              if (value.length > 150) {
                                return "O tamanho máximo do campo é 150 caracteres";
                              }
                              return null;
                            }),
                      ],
                    ),

                    /// end email field

                    SizedBox(
                      height: 10,
                    ),
                    //// field password
                    Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            direction: constraints.maxWidth < 250
                                ? Axis.vertical
                                : Axis.horizontal,
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Senha",
                                style: AppTextStyle.inputTextStyle,
                              ),
                              TextButton(
                                  focusNode: FocusNode(skipTraversal: true),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.forgetPassword);
                                  },
                                  style: ButtonStyle(textStyle:
                                      WidgetStateTextStyle.resolveWith(
                                          (Set<WidgetState> state) {
                                    if (state.contains(WidgetState.hovered)) {
                                      return AppTextStyle.linkHoverTextStyle;
                                    }
                                    return AppTextStyle.linkTextStyle;
                                  })),
                                  child: Text(
                                    "Esqueceu a senha?",
                                    style: AppTextStyle.linkTextStyle,
                                    textAlign: TextAlign.right,
                                  ))
                            ],
                          ),
                        ),
                        TextFormFieldWidget(
                          focusNode: passwordFocusNode,
                          controller: passwordEDC,
                          autofillHints: [AutofillHints.password],
                          prefixIcon: Icon(Icons.lock),
                          obscureText: true,
                          textInputAction: TextInputAction.send,
                          readOnly: controller.value is AuthLoading,
                          onFieldSubmited: (_) => _formSubmit(),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                            {
                              return "Campo obrigatório";
                            }

                            if (value.isSqlInjection) {
                              return "Valor inválido para o campo";
                            }
                            if (value.length < 8) {
                              return "O tamanho minímo do campo é 8 caracteres";
                            }
                            return null;
                          },
                        )
                      ],
                    ),

                    /// end password field
                    ///
                    SizedBox(
                      height: 20,
                    ),

                    ElevatedButtonWidget(
                      title: (controller.value is AuthLoading) ? "" : "Entrar",
                      onPressed:
                          controller.value is AuthLoading ? null : _formSubmit,
                      backgroundColor: AppColors.gold,
                      hoverColor: AppColors.gold.withAlpha(200),
                      icon: (controller.value is AuthLoading)
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Icon(Icons.login),
                    ),

                    SizedBox(
                      height: 20,
                      child: controller.value is AuthFailure
                          ? (controller.value as AuthFailure).error == null
                              ? null
                              : Wrap(
                                  children: (controller.value as AuthFailure)
                                      .error!
                                      .map<Widget>(
                                        (e) => Text(
                                          e.message,
                                          style: AppTextStyle.errorTextStyle,
                                        ),
                                      )
                                      .whereType<Widget>()
                                      .toList(),
                                )
                          : null,
                    ),

                    /// line or
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "OU",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    /// enf line or
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        direction: constraints.maxWidth < 250
                            ? Axis.vertical
                            : Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Text(
                            "Não possui uma conta?",
                            style: AppTextStyle.inputTextStyle
                                .copyWith(fontSize: 16),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.signIn);
                              },
                              style: ButtonStyle(textStyle:
                                  WidgetStateTextStyle.resolveWith(
                                      (Set<WidgetState> state) {
                                if (state.contains(WidgetState.hovered)) {
                                  return AppTextStyle.linkHoverTextStyle;
                                }
                                return AppTextStyle.linkTextStyle;
                              })),
                              child: Text("Criar Conta",
                                  style: AppTextStyle.linkTextStyle,
                                  textAlign: TextAlign.right))
                        ],
                      ),
                    )
                  ],
                ))),
          ),
        ),
      ),
    );
  }

  void _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      await appController.checkNetwork();
      await controller.signIn(loginEDC.text, passwordEDC.text);
    }
  }
}
