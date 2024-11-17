import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:drahkma/config.dart';
import 'package:drahkma/dashboard/dashboard_dto.dart';
import 'package:drahkma/dashboard/data_notifier.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsWidgetTotalAmountGroup extends StatelessWidget {
  final List<AmountGroupDto>? data;
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
  List<XyDataSeries<AmountGroupDto, String>> _series() {
    List<ColumnSeries<AmountGroupDto, String>> series = [];
    HashSet categories = HashSet();

    for (AmountGroupDto dt in data!) {
      categories.add(dt.description);
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
        xValueMapper: (AmountGroupDto amounts, _) =>
            amounts.description,
        yValueMapper: (AmountGroupDto amount, _) =>
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
  // _barChartAmmounts(List<AmountGroupDto> data) {
  //   return ConstrainedBox(
  //     constraints: BoxConstraints.expand(width: 800, height: 400),
  //     child: Chart<AmountGroupDto>(
  //       data: data,
  //       variables: {
  //         'descrição': Variable(
  //             accessor: (AmountGroupDto el) => el.description as String),
  //         'total': Variable(
  //             accessor: (AmountGroupDto el) => el.total as double,
  //             scale: LinearScale(
  //                 title: "Total",
  //                 formatter: (data) => Config.currencyFormat.format(data)))
  //       },
  //       marks: [
  //         IntervalMark(
  //             label: LabelEncode(
  //               encoder: (tuple) => Label(
  //                 Config.currencyFormat.format(tuple['total']),
  //                 LabelStyle(
  //                   textStyle: const TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             elevation: ElevationEncode(value: 0, updaters: {
  //               'tap': {true: (_) => 5}
  //             }),
  //             color: ColorEncode(value: Defaults.primaryColor, updaters: {
  //               'tap': {false: (color) => color.withAlpha(100)}
  //             })),
  //       ],
  //       axes: [
  //         AxisGuide(
  //             dim: Dim.y,
  //             label: LabelStyle(
  //                 textStyle: const TextStyle(color: Colors.lightBlue),
  //                 offset: Defaults.verticalAxis.label!.offset),
  //             variable: "total",
  //             // layer: 10,
  //             grid: Defaults.strokeStyle),
  //         AxisGuide(
  //           dim: Dim.x,
  //           line: Defaults.horizontalAxis.line,
  //           label: LabelStyle(
  //               textStyle: const TextStyle(color: Colors.white),
  //               offset: Defaults.horizontalAxis.label!.offset),
  //         )
  //       ],
  //       selections: {'tap': PointSelection(dim: Dim.x)},
  //       tooltip: TooltipGuide(),
  //       crosshair: CrosshairGuide(),
  //       padding: (size) => EdgeInsets.fromLTRB(
  //           size.width * 0.05, size.width * 0.05, 1, size.width * 0.05),
  //     ),
  //   );
  // }
}

//////
///
///
///
class ChartsWidgetTotalAmountTranferBank extends StatelessWidget {
  final List<AmountTransferBankGroupDto>? data;
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

  List<XyDataSeries<AmountTransferBankGroupDto, String>> _series() {
    List<ColumnSeries<AmountTransferBankGroupDto, String>> series = [];
    HashSet categories = HashSet();

    for (AmountTransferBankGroupDto dt in data!) {
      categories.add(dt.description);
    }

    Random random = Random();
    Color color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    Color lastColor = color;

    categories.forEach((el) {
      color = Colors.primaries[random.nextInt(Colors.primaries.length)];

      if (color == lastColor) {
        color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      }

      series.add(ColumnSeries(
        dataSource: data,
        dataLabelMapper: (AmountTransferBankGroupDto amount, _) =>
            amount.description,
        xValueMapper: (AmountTransferBankGroupDto amounts, _) =>
            amounts.description == el ? amounts.type?.name as String : null,
        yValueMapper: (AmountTransferBankGroupDto amount, _) =>
            amount.total as double,
        sortingOrder: SortingOrder.ascending,
        sortFieldValueMapper: (datum, index) => datum.type?.name.hashCode,
        name: el,
        enableTooltip: true,
        width: 0.2,
        color: color,
      ));
    });

    return series;
  }
}
