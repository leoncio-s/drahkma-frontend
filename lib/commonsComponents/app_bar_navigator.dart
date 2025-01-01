import 'package:flutter/material.dart';
import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/commonsComponents/statefullwidget.dart';

// ignore: must_be_immutable
class AppBarNavigator extends StatelessWidget {
  final List<StatefulwidgetDrahkma> childrens;

  const AppBarNavigator({super.key, required this.childrens});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: childrens.length,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0.7,
              excludeHeaderSemantics: false,
              title: const Text("Drahkma"),
              forceMaterialTransparency: true,
              toolbarHeight: 30,
              actions: [
                ElevatedButton.icon(
                    onPressed: () {
                      AuthService.logout();
                      Navigator.of(context).pushReplacementNamed("/auth/login");
                    }, label: const Tooltip(message: "Sair", child:  Icon(Icons.exit_to_app)),)
              ],
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).hoverColor,
                  // indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Theme.of(context).secondaryHeaderColor,
                  // enableFeedback: true,
                  indicatorWeight: 10.0,
                  // indicatorPadding: EdgeInsets.all(90),
                  tabs: childrens
                      .map((el) =>
                      ConstrainedBox(constraints: const BoxConstraints(maxHeight: 60, minHeight: 30, minWidth: 40,  maxWidth: 200), child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: MediaQuery.of(context).size.width > 500 ? Tab(
                              icon:el.icon,
                              height: 50,
                              text: MediaQuery.of(context).size.width > 500 ? el.name : null,
                            ) :
                      Tooltip(
                            // icon: el.icon,
                            height: 50,
                            message: el.name,
                            // child: Text(el.name),
                            child: Tab(
                              icon: el.icon,
                              height: 50,
                            )
                          )),
                      ),)
                      
                      .toList())),
          body: TabBarView(children: childrens),
        ));
  }
}
