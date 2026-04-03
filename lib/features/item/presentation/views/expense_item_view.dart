import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_expense.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/item/presentation/views/items_view.dart';

class ExpenseItemView extends DrahkmaStatefulWidget {
  const ExpenseItemView(
      {super.key,
      super.name = "Despesas",
      super.icon = const Icon(
        Icons.trending_down,
        size: 20,
      )});

  @override
  State<StatefulWidget> createState() => _OutflowState();
}

class _OutflowState extends State<ExpenseItemView> {
  @override
  Widget build(BuildContext context) {
    return ItemsView(
      title: "Despesas",
      getData: getIt<ItemGetExpense>().call,
      expense: true,
    );
  }
}
