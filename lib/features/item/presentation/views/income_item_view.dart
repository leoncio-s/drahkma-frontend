import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_income.dart';
import 'package:drahkma/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/item/presentation/views/items_view.dart';

class IncomeItemView extends DrahkmaStatefulWidget {
  const IncomeItemView(
      {super.key,
      super.name = "Receitas",
      super.icon = const Icon(
        Icons.trending_up,
        size: 20,
      )});

  @override
  State<IncomeItemView> createState() => InflowState();
}

class InflowState extends State<IncomeItemView> {
  @override
  Widget build(BuildContext context) {
    return ItemsView(
      title: "Receitas",
      getData: getIt<ItemGetIncome>().call,
      expense: false,
    );
  }
}
