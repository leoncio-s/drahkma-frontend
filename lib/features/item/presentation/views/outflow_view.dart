import 'package:drahkma/features/items/data/datasources/items_remote_datasource.dart';
import 'package:drahkma/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/items/presentation/views/items_view.dart';

class OutflowView extends DrahkmaStatefulWidget {
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
    return ItemsView(title: "Despesas", getData: ItemsRemoteDatasource().getOutflow, expense: true,);
  }
}
