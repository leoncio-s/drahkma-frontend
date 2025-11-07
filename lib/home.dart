import 'dart:async';

import 'package:drahkma/BankAccounts/bank_accounts_view.dart';
import 'package:drahkma/Cards/cards_view.dart';
import 'package:drahkma/Categories/categories_view.dart';
import 'package:drahkma/Dashboard/dash_amounts.dart';
import 'package:drahkma/Items/inflow_view.dart';
import 'package:drahkma/Items/outflow_view.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:drahkma/CommonsComponents/app_bar_navigator.dart';
import 'package:drahkma/CommonsComponents/statefullwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {

  void _toLogin(){
    SchedulerBinding.instance.addPostFrameCallback((_){
      if(mounted) Navigator.of(context).pushReplacementNamed("/auth/login");
    });
  }

  Future<UserDto?> _profile()async{
    Future.delayed(const Duration(milliseconds: 200));
    return await UserService.profile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _profile(), builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return const Center(child: CircularProgressIndicator(),);
      }
      if(snapshot.hasError)
      {
        _toLogin();
        return const Center(child: CircularProgressIndicator(),);
      }
      return const AppBarNavigator(
      childrens: <StatefulWidgetDrahkma>[
        Dashboard(),
        InflowView(),
        OutflowView(),
        CategoriesView(),
        BankAccountsView(),
        CardsView()
      ],
    );
    });
  }
}
