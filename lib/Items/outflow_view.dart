import 'package:flutter/material.dart';
import 'package:drahkma/Items/items_service.dart';
import 'package:drahkma/Items/items_view.dart';
import 'package:drahkma/CommonsComponents/statefullwidget.dart';

class OutflowView extends StatefulWidgetDrahkma {
  const OutflowView(
      {super.key,
      super.name = "Despesas",
      super.icon = const Icon(
        Icons.trending_down,
        size: 20,
      )});

  @override
  State<StatefulWidget> createState() => _OutflowState();
}

class _OutflowState extends State<OutflowView> {
  @override
  Widget build(BuildContext context) {
    return ItemsView(title: "Despesas", getData: ItemsService().getOutflow, expense: true,);
  }
}
