import 'package:drahkma/features/item/presentation/controllers/item_controller.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/item/presentation/views/items_view.dart';

class IncomeItemView extends DrahkmaStatefulWidget {
  final ItemController itemController;
  const IncomeItemView(
      {super.key,
      super.name = "Receitas",
      super.icon = const Icon(
        Icons.trending_up,
        size: 20,
      ),
      required this.itemController});

  @override
  State<IncomeItemView> createState() => InflowState();
}

class InflowState extends State<IncomeItemView> {
  @override
  Widget build(BuildContext context) {
    return ItemsView(
      title: "Receitas",
      itemController: widget.itemController,
      expense: false,
    );
  }
}
