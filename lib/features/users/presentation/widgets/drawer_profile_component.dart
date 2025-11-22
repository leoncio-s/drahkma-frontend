import 'package:drahkma/core/exceptions/unauthenticated_exception.dart';
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/data/models/auth.dart';
import 'package:drahkma/features/users/data/models/user.dart';
import 'package:drahkma/features/users/data/datasources/user_remote_datasource.dart';
import 'package:drahkma/features/users/presentation/pages/new_password_form_page.dart';
import 'package:drahkma/presentation/widgets/elevated_button_widget.dart';
import 'package:drahkma/presentation/widgets/snack_bar_widget.dart';
import 'package:drahkma/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class DrawerProfileComponent extends StatefulWidget {
  const DrawerProfileComponent({super.key});

  @override
  State<DrawerProfileComponent> createState() => _DrawerProfileComponentState();
}

class _DrawerProfileComponentState extends State<DrawerProfileComponent> {
  late Size size;
  double widthDrawer = 400.0;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = MaskedTextController(mask: "(00) 000 000 000");
  
  void _toLogin(){
    SchedulerBinding.instance.addPostFrameCallback((_){
      if(mounted) Navigator.of(context).pushReplacementNamed("/auth/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (size.width < 250) {
      widthDrawer = size.width;
    } else if (size.width < 500) {
      widthDrawer = size.width * 0.8;
    }

    return Drawer(
        width: widthDrawer,
        backgroundColor: Theme.of(context).primaryColorDark,
        child: FutureBuilder<User?>(
            future: AuthRemoteDatasource.getAuthUser(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snap.hasData)
              {
                _fullName.text=snap.data!.fullname ?? '';
                _email.text = snap.data!.email ?? '';
                _phone.text = snap.data!.phoneNumber ?? '';

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 30.0,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  splashRadius: 1.0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close))),
                        ),
                        DrawerHeader(
                            child: SizedBox.expand(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Container(
                              constraints:
                                  BoxConstraints(maxWidth: widthDrawer),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipOval(
                                child: TapRegion(
                                    onTapInside: (ev) {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child:
                                          Image.asset("images/logo_yellow.png"),
                                    )),
                              ),
                            ),
                          ),
                        )),
                        _userForm(),
                      ],
                    ),
                  )
                ],
              );}

            _toLogin();
            return Center(child: Text("Não foi possível obter dados do usuário, faça o login novamente."),);
            }));
  }

  Form _userForm() {
    return Form(
        key: _formKey,
        child: Column(
      children: [
        TextFormFieldWidget(
          labelText: "Nome Completo",
          controller: _fullName,
          validator: (value) {
            if (value!.isEmpty) {
              return "Campo obrigatório";
            } else if (value.length < 3 || value.length > 100) {
              return "O tamanho minímo para o campo é 3 e o máximo é 100";
            }
            return null;
          },
        ),
        SizedBox(
          height: 25,
        ),
        TextFormFieldWidget(
          labelText: "E-mail",
          readOnly: true,
          controller: _email,
          validator: (value){
            if (value!.isEmpty) {
              return "Campo Obrigatório";
            }
            var validate = Auth.validateEmail(value);
            if (validate is Map) {
              return validate['error'];
            }
            return null;
          },
        ),
        SizedBox(
          height: 25,
        ),
        TextFormFieldWidget(
          labelText: "Telefone",
          controller: _phone,
          maxLength: 16,
          validator:(value) {
                    
            if (value!.isEmpty) {
              return "Campo Obrigatório";
            }
            if(value.replaceAll(RegExp(r"[\(\)\s)-]+"), "").length < 11 || value.replaceAll(RegExp(r"[\(\)\s)-]+"), "").length > 11) return "Valor informado é inválido";
            return null;
          },
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButtonWidget(
              title: "Alterar Senha",
              onPressed: ()async{
                await showDialog(
                  context: context,
                  builder: (context)=> NewPasswordFormPage());
              },
              width: (widthDrawer / 2) * 0.9,
              backgroundColor: Colors.grey,
            ),
            ElevatedButtonWidget(
              title: "Alterar Dados",
              onPressed: _submitForm,
              width: (widthDrawer / 2) * 0.9,
            )
          ],
        )
      ],
    ));
  }

  Future<void> _submitForm() async{
    if(_formKey.currentState!.validate()){
      User user = User(
        fullname: _fullName.text,
        email: _email.text,
        phoneNumber: _phone.text.replaceAll(RegExp(r"[\(\)\s)-]+"), "")
      );
      SnackBarWidget snack = SnackBarWidget(content: Text(""));
      try{
        var service = await UserRemoteDatasource.update(user);
        if(service is bool)
        {
          snack = SnackBarWidget(content: Text("Dados Atualizados!"), backgroundColor: Colors.green,);
        }else{
          if(service['message'] != null)
          {
            snack = SnackBarWidget(content: Text(service['message'].toString()), backgroundColor: Colors.redAccent,);
          }
        }
        if(mounted) Navigator.of(context).pop([true]);
      }on UnauthenticatedException catch (e)
      {
        snack = SnackBarWidget(content: Text(e.message), backgroundColor: Colors.redAccent,);
        if(mounted) Navigator.of(context).pushReplacementNamed("/auth/login");
      }on Exception catch(e){
        snack = SnackBarWidget(content: Text(e.toString()), backgroundColor: Colors.redAccent,);
      }finally{
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
        }
      }
      return;
    }
    return;
  }
}
