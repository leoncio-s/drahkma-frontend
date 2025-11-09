import 'package:flutter/material.dart';

class DrawerMenuComponent extends StatefulWidget
{
  const DrawerMenuComponent({super.key});

  @override
  State<DrawerMenuComponent> createState() => _DrawerMenuComponentState();
}

class _DrawerMenuComponentState extends State<DrawerMenuComponent>
{
  late Size size;
  double widthDrawer = 400.0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if(size.width < 250){
      widthDrawer = size.width;
    }else if(size.width < 500){
      widthDrawer = size.width * 0.8;
    }

    return Drawer(
      width: widthDrawer,
      backgroundColor: Theme.of(context).primaryColorDark, 
      child: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30.0,
            child: Align(
              alignment: Alignment.centerRight, 
              child: IconButton(
                splashRadius: 1.0,
                onPressed: (){Navigator.of(context).pop();}, 
                icon: const Icon(Icons.close))),
          ),
          DrawerHeader(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 80.0, 
                maxWidth: 400.0, 
                minHeight: 80.0, 
                maxHeight: 400.0), 
              child: Image.asset(
                "images/logo_yellow.png", 
                alignment: Alignment.center, 
                scale: 2.0,
                errorBuilder: (c, er, st){
                  return Text("DRAHKMA", style: Theme.of(context).textTheme.titleLarge,);
                },
                ),
                )
            )
        ],
      )
    );
  }
}