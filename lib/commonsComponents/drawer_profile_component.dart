import 'package:drahkma/CommonsComponents/elevated_button_component.dart';
import 'package:drahkma/CommonsComponents/text_form_field_component.dart';
import 'package:drahkma/User/create_user_form.dart';
import 'package:flutter/material.dart';

class DrawerProfileComponent extends StatefulWidget {
  const DrawerProfileComponent({super.key});

  @override
  State<DrawerProfileComponent> createState() => _DrawerProfileComponentState();
}

class _DrawerProfileComponentState extends State<DrawerProfileComponent> {
  late Size size;
  double widthDrawer = 400.0;

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
        child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1)),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
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
                      child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 10,
                            color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipOval(
                        child: TapRegion(
                            onTapInside: (ev) {
                              return;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset("images/logo_yellow.png"),
                            )),
                      ),
                    ),
                  )),
                  _userForm()
                ],
              );
            }));
  }

  _userForm(){
    // return Form(
    //     child: Column(
    //     children: [
    //       TextFormFieldComponent(labelText: "Nome Completo"),
    //       TextFormFieldComponent(labelText: "E-mail", readOnly: true,),
    //       TextFormFieldComponent(labelText: "Telefone"),
    //       TextFormFieldComponent(labelText: "Senha atual", obscureText: true),
    //       TextFormFieldComponent(labelText: "Nova Senha", obscureText: true),
    //       TextFormFieldComponent(labelText: "Confirmar Nova Senha", obscureText: true),
    //       ElevatedButtonComponent(title: "Alterar", onPressed: (){
    //         _submitForm();
    //       })
    //     ],
    //       ));
    return CreateUserForm();
  }

  _submitForm(){
    return;
  }
}
