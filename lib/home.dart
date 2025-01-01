import 'dart:async';

import 'package:drahkma/BankAccounts/bank_accounts_view.dart';
import 'package:drahkma/Cards/cards_view.dart';
import 'package:drahkma/Categories/categories_view.dart';
import 'package:drahkma/Dashboard/dash_amounts.dart';
import 'package:drahkma/Items/inflow_view.dart';
import 'package:drahkma/Items/outflow_view.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:drahkma/commonsComponents/app_bar_navigator.dart';
import 'package:drahkma/commonsComponents/statefullwidget.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late UserDto? authUser;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      UserService.profile().then((n) => null).onError((e, s) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/auth/login");
      }).timeout(const Duration(seconds: 20), onTimeout: () {
        // setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Erro ao se conectar ao Site, tente novamente em outro momento"),
          showCloseIcon: true,
        ));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AppBarNavigator(
      childrens: <StatefulwidgetDrahkma>[
        Dashboard(),
        InflowView(),
        OutflowView(),
        CategoriesView(),
        BankAccountsView(),
        CardsView()
      ],
    );
  }
}
