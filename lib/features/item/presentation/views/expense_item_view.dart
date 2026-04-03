import 'package:drahkma/features/item/presentation/controllers/item_controller.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/item/presentation/views/items_view.dart';

class ExpenseItemView extends DrahkmaStatefulWidget {
  final ItemController itemController;
  const ExpenseItemView(
      {super.key,
      super.name = "Despesas",
      super.icon = const Icon(
        Icons.trending_down,
        size: 20,
      ),
      required this.itemController});

  @override
  State<StatefulWidget> createState() => _OutflowState();
}

class _OutflowState extends State<ExpenseItemView> {
  @override
  Widget build(BuildContext context) {
    return ItemsView(
      title: "Despesas",
      itemController: widget.itemController,
      expense: true,
    );
  }
}
