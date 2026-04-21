import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/amount/presentation/pages/dashboard_amount_page.dart';
import 'package:drahkma/features/bank_account/presentation/views/bank_account_view.dart';
import 'package:drahkma/features/card/presentation/views/card_view.dart';
import 'package:drahkma/features/category/presentation/views/category_view.dart';
import 'package:drahkma/features/item/presentation/views/income_item_view.dart';
import 'package:drahkma/features/item/presentation/views/expense_item_view.dart';
import 'package:drahkma/features/user/domain/usecases/user_profile.dart';
import 'package:drahkma/core/presentation/widgets/app_bar_navigator_widget.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
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
      if(mounted)
      {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    UserProfile userPofile = getIt<UserProfile>();
    
    return FutureBuilder(future: userPofile.call(), builder: (context, snapshot){
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
        // AmountsPage(),
        DashboardAmountPage(amountController: getIt(),),
        IncomeItemView(itemController: getIt()),
        ExpenseItemView(itemController: getIt()),
        CategoryView(categoryController: getIt()),
        BankAccountView(bankAccountController: getIt()),
        CardView(cardController: getIt())
      ],
    );
    });
  }
}
