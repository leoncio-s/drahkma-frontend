import 'package:drahkma/features/items/data/datasources/items_remote_datasource.dart';
import 'package:drahkma/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/items/presentation/views/items_view.dart';

class InflowView extends DrahkmaStatefulWidget {
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
      getData: ItemsRemoteDatasource().getInflow,
      expense: false,
    );
  }
}
