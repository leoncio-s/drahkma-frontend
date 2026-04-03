import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/amount/presentation/pages/dashboard_amount_page.dart';
import 'package:drahkma/features/bank_account/presentation/views/bank_account_view.dart';
import 'package:drahkma/features/bank_account/presentation/controllers/bank_account_controller.dart';
import 'package:drahkma/features/card/presentation/views/card_view.dart';
import 'package:drahkma/features/card/presentation/controllers/card_controller.dart';
import 'package:drahkma/features/category/presentation/views/Category_view.dart';
import 'package:drahkma/features/category/presentation/controllers/category_controller.dart';
import 'package:drahkma/features/item/presentation/views/income_item_view.dart';
import 'package:drahkma/features/item/presentation/views/expense_item_view.dart';
import 'package:drahkma/features/item/presentation/controllers/item_controller.dart';
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
      if(mounted) Navigator.of(context).pushReplacementNamed("login");
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
        DashboardAmountPage(),
        IncomeItemView(itemController: getIt<ItemController>()),
        ExpenseItemView(itemController: getIt<ItemController>()),
        CategoryView(categoryController: getIt<CategoryController>()),
        BankAccountView(bankAccountController: getIt<BankAccountController>()),
        CardView(cardController: getIt<CardController>())
      ],
    );
    });
  }
}
