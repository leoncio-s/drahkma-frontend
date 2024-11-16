import 'package:flutter/material.dart';
import 'package:front_lfinanca/Items/items_service.dart';
import 'package:front_lfinanca/Items/items_view.dart';
import 'package:front_lfinanca/commonsComponents/statefullwidget.dart';

class InflowView extends StatefulwidgetLfinanca {
  const InflowView(
      {super.key,
      super.name = "Receitas",
      super.icon = const Icon(
        Icons.trending_up,
        size: 20,
      )});

  @override
  State<StatefulWidget> createState() => InflowState();
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
