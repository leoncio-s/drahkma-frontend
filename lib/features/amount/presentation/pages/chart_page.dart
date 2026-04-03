import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:drahkma/features/amount/data/models/amount_model.dart';
import 'package:drahkma/features/amount/data/models/transfer_bank_amount_model.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/presentation/notifiers/data_notifier.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsWidgetTotalAmountGroup extends StatelessWidget {
  final List<AmountModel>? data;
  final String title;

  const ChartsWidgetTotalAmountGroup(
      {super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 900.0,
            // maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            shadowColor: Colors.blueGrey,
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox.fromSize(
                          size: const Size.fromHeight(10.0),
                        ),
                        ListenableBuilder(
                            listenable: dataNotifier,
                            builder: (c, w) {
                              return data == null || data!.isEmpty
                                  ? const Text("Sem dados")
                                  : _barChartAmmounts();
                            })
                      ],
                    )))));
  }
  Widget _barChartAmmounts({String title = ""}) {
    return SfCartesianChart(
      legend: const Legend(isVisible: true, isResponsive: true),
      title: ChartTitle(text: title),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: NumericAxis(
        numberFormat: Config.currencyFormat,
      ),
      series: _series(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
  List<XyDataSeries<AmountModel, String>> _series() {
    List<ColumnSeries<AmountModel, String>> series = [];
    HashSet category = HashSet();

    for (AmountModel dt in data!) {
      category.add(dt.description);
    }

    Random random = Random();
    Color color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    Color lastColor = color;

      color = Colors.primaries[random.nextInt(Colors.primaries.length)];

      if (color == lastColor) {
        color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      }

      series.add(ColumnSeries(
        dataSource: data,
        // dataLabelMapper: (AmountGroupDto amount, _) =>
        //     amount.description,
        xValueMapper: (AmountModel amounts, _) =>
            amounts.description,
        yValueMapper: (AmountModel amount, _) =>
            amount.total as double,
        // sortingOrder: SortingOrder.ascending,
        // sortFieldValueMapper: (datum, index) => datum.description,
        // enableTooltip: true,
        name: "",
        width: 0.2,
        // color: color,
      ));

    return series;
  }
}

//////
///
///
///
class ChartsWidgetTotalAmountTranferBank extends StatelessWidget {
  final List<TransferBankAmountModel>? data;
  final String title;

  const ChartsWidgetTotalAmountTranferBank(
      {super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 900.0, minHeight: 156.25, minWidth: 250.0)),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            shadowColor: Colors.blueGrey,
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox.fromSize(
                          size: const Size.fromHeight(10.0),
                        ),
                        ListenableBuilder(
                            listenable: dataNotifier,
                            builder: (c, w) {
                              return data == null || data!.isEmpty
                                  ? const Text("Sem dados")
                                  : _barChartAmmounts();
                            })
                      ],
                    )))));
  }

  Widget _barChartAmmounts({String title = ""}) {
    return SfCartesianChart(
      legend: const Legend(isVisible: true, isResponsive: true),
      title: ChartTitle(text: title),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: NumericAxis(
        numberFormat: Config.currencyFormat,
      ),
      series: _series(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<XyDataSeries<TransferBankAmountModel, String>> _series() {
    List<ColumnSeries<TransferBankAmountModel, String>> series = [];
    HashSet category = HashSet();

    for (TransferBankAmountModel dt in data!) {
      category.add(dt.description);
    }

    Random random = Random();
    Color color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    Color lastColor = color;

    for (var el in category) {
      color = Colors.primaries[random.nextInt(Colors.primaries.length)];

      if (color == lastColor) {
        color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      }

      series.add(ColumnSeries(
        dataSource: data,
        dataLabelMapper: (TransferBankAmountModel amount, _) =>
            amount.description,
        xValueMapper: (TransferBankAmountModel amounts, _) =>
            amounts.description == el ? amounts.type?.name as String : null,
        yValueMapper: (TransferBankAmountModel amount, _) =>
            amount.total as double,
        sortingOrder: SortingOrder.ascending,
        sortFieldValueMapper: (datum, index) => datum.type?.name.hashCode,
        name: el,
        enableTooltip: true,
        width: 0.2,
        color: color,
      ));
    }

    return series;
  }
}
