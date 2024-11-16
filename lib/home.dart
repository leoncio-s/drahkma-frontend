import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_lfinanca/BankAccounts/bank_accounts_view.dart';
import 'package:front_lfinanca/Cards/cards_view.dart';
import 'package:front_lfinanca/Categories/categories_view.dart';
import 'package:front_lfinanca/Dashboard/dash_amounts.dart';
import 'package:front_lfinanca/Items/inflow_view.dart';
import 'package:front_lfinanca/Items/outflow_view.dart';
import 'package:front_lfinanca/User/user_dto.dart';
import 'package:front_lfinanca/User/user_service.dart';
import 'package:front_lfinanca/commonsComponents/app_bar_navigator.dart';

class HomeView extends StatefulWidget{

  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}


class HomeViewState extends State<HomeView>{

  late UserDto? authUser;

  @override
  void initState() {

    Timer(const Duration(seconds: 2), (){
      UserService.profile().then((n)=>null).onError((e, s) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "/auth/login");
    }).timeout(const Duration(seconds: 20), onTimeout: (){
      // setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao se conectar ao Site, tente novamente em outro momento"), showCloseIcon: true,)
      );
    });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return const AppBarNavigator(
      childrens: [
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