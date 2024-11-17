import 'package:flutter/material.dart';
import 'package:drahkma/Items/items_service.dart';
import 'package:drahkma/Items/items_view.dart';
import 'package:drahkma/commonsComponents/statefullwidget.dart';

class InflowView extends StatefulwidgetDrahkma {
  const InflowView(
      {super.key,
      super.name = "Receitas",
      super.icon = const Icon(
        Icons.trending_up,
        size: 20,
      )});

  @override
  State<InflowView> createState() => InflowState();
}

class InflowState extends State<InflowView> {
  @override
  Widget build(BuildContext context) {
    return ItemsView(
      title: "Receitas",
      getData: ItemsService().getInflow,
      expense: false,
    );
  }
}
