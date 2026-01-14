import 'package:drahkma/core/exceptions/unauthenticated_exception.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/models/auth_model.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:drahkma/features/users/domain/usecases/user_update.dart';
import 'package:drahkma/features/users/presentation/pages/new_password_form_page.dart';
import 'package:drahkma/presentation/dialogs/modal_dialog.dart';
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

    AuthLocalDatasource localDataSource = getIt<AuthLocalDatasource>();

    return Drawer(
        width: widthDrawer,
        backgroundColor: Theme.of(context).primaryColorDark,
        child: FutureBuilder<UserModel?>(
            future: localDataSource.getAuthToken(),
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
                );
              }

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
            var validate = AuthModel.validateEmail(value);
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

  void _submitForm() async{
    var _clModal = modalDialog(context, 'loading');
    if(_formKey.currentState!.validate()){
      SnackBarWidget? snack;
      try{
        UserModel user = UserModel(
          fullname: _fullName.text,
          email: _email.text,
          phoneNumber: _phone.text.replaceAll(RegExp(r"[\(\)\s)-]+"), "")
        );
        
        final useCase = getIt<UserUpdate>();

        await useCase.call(user: user);
        snack = SnackBarWidget(content: Text("Dados Atualizados!"), backgroundColor: Colors.green,);

      }on UnauthenticatedException catch (e)
      {
        snack = SnackBarWidget(content: Text(e.message), backgroundColor: Colors.redAccent,);
        if(mounted) Navigator.of(context).pushReplacementNamed("/auth/login");
      }on ArgumentError catch(e)
      {
        snack = SnackBarWidget(content: Text(e.invalidValue), backgroundColor: Colors.redAccent,);
      } catch(e){
        snack = SnackBarWidget(content: Text(e.toString()), backgroundColor: Colors.redAccent,);
      }finally{
        _clModal();
        if(mounted && snack != null)
        {
          ScaffoldMessenger.of(context).showSnackBar(snack as SnackBar);
          Navigator.of(context).pop([false]);
        }
      }
    }
  }
}
