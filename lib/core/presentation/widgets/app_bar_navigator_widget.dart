
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/domain/usecases/logout_use_case.dart';
import 'package:flutter/material.dart';

class AppBarNavigatorWidget extends StatelessWidget {
  final List<DrahkmaStatefulWidget> childrens;

  const AppBarNavigatorWidget({super.key, required this.childrens});

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
                      getIt<LogoutUseCase>().call();
                      Navigator.of(context).pushReplacementNamed("/auth/login");
                    }, label: const Tooltip(message: "Sair", child:  Icon(Icons.exit_to_app)),)
              ],
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).hoverColor,
                  labelColor: Theme.of(context).secondaryHeaderColor,
                  indicatorWeight: 10.0,
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
                            constraints: BoxConstraints.expand(height: 50),
                            message: el.name,
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
