import 'dart:async';

import 'package:drahkma/features/bank_accounts/presentation/views/bank_accounts_view.dart';
import 'package:drahkma/features/cards/presentation/views/cards_view.dart';
import 'package:drahkma/features/categories/presentation/views/categories_view.dart';
import 'package:drahkma/features/users/data/datasources/user_remote_datasource.dart';
import 'package:drahkma/features/users/data/models/user.dart';
import 'package:drahkma/features/amounts/presentation/pages/dashboard_page.dart';
import 'package:drahkma/features/items/presentation/views/inflow_view.dart';
import 'package:drahkma/features/items/presentation/views/outflow_view.dart';
import 'package:drahkma/presentation/widgets/app_bar_navigator_widget.dart';
import 'package:drahkma/presentation/widgets/drahkma_stateful_widget.dart';
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

  Future<User?> _profile()async{
    Future.delayed(const Duration(milliseconds: 200));
    return await UserRemoteDatasource.profile();
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
      return AppBarNavigatorWidget(
      childrens: <DrahkmaStatefulWidget>[
        AmountsPage(),
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
