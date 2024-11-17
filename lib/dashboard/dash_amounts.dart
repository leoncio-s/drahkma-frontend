import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:drahkma/commonsComponents/statefullwidget.dart';
import 'package:drahkma/config.dart';
import 'package:drahkma/dashboard/charts_page.dart';
import 'package:drahkma/dashboard/dashboard_dto.dart';
import 'package:drahkma/dashboard/data_notifier.dart';
import 'package:drahkma/dashboard/date_range.dart';

class Dashboard extends StatefulwidgetDrahkma{
  const Dashboard(
      {super.key,
      super.name = "Dashboard",
      super.icon = const Icon(Icons.dashboard, size: 20)});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static final AppNotifier _notifier = appNotifier;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _Cards(
      notifier: _notifier,
      dataNotifier: dataNotifier,
    )
        // child: _Cards(data: data, notifier: _notifier),
        );
  }
}

// ignore: must_be_immutable
class _Cards extends StatelessWidget {
  _Cards({super.key, required this.notifier, required dataNotifier});

  AppNotifier notifier;
  DashboardDto data = dataNotifier.data;

  @override
  StatelessElement createElement() {
    dataNotifier.getData(notifier.dateTimeRange);
    notifier.addListener(() {
      Timer.periodic(const Duration(seconds: 2), dataNotifier.getData(appNotifier.dateTimeRange));
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900.00),
        child: Wrap(
          alignment: WrapAlignment.center,
          clipBehavior: Clip.hardEdge,
          children: [
            SizedBox.fromSize(
              size: const Size.fromHeight(30),
            ),
            _period(context),
            SizedBox.fromSize(
              size: const Size.fromHeight(30.0),
            ),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balance(context, dataNotifier.data.amount);
                }),

            // _balanceInflow(context, value),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balanceInflow(context, dataNotifier.data.inflow);
                }),

            // _balanceOutflow(context),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balanceOutflow(context, dataNotifier.data.outflow);
                }),
            // _balanceInflowCards(context),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balanceInflowCards(
                      context, dataNotifier.data.totalAmountInflowCards);
                }),
            // _balanceOutflowCards(context),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balanceOutflowCards(
                      context, dataNotifier.data.totalAmountOutflowCards);
                }),
            // _balanceInflowTransferBank(context),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balanceInflowTransferBank(
                      context, dataNotifier.data.totalAmountInflowTransferBank);
                }),
            // _balanceOutflowTransferBank(context),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  return _balanceOutflowTransferBank(context,
                      dataNotifier.data.totalAmountOutflowTransferBank);
                }),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  // print("AQUI ALTEROU: ${dataNotifier.data}");
                  return ChartsWidgetTotalAmountGroup(
                    data: dataNotifier.data.amountInflowCategory,
                    title: "Receitas por Categoria",
                  );
                }),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  // print("AQUI ALTEROU: ${dataNotifier.data}");
                  return ChartsWidgetTotalAmountGroup(
                    data: dataNotifier.data.amountInflowCard,
                    title: "Receitas por Cartão",
                  );
                }),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  // print("AQUI ALTEROU: ${dataNotifier.data}");
                  return ChartsWidgetTotalAmountGroup(
                    data: dataNotifier.data.amountOutflowCategory,
                    title: "Despesas por Categoria",
                  );
                }),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  // print("AQUI ALTEROU: ${dataNotifier.data}");
                  return ChartsWidgetTotalAmountGroup(
                    data: dataNotifier.data.amountOutflowCard,
                    title: "Despesas por Cartão",
                  );
                }),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  // print("AQUI ALTEROU: ${dataNotifier.data}");
                  return ChartsWidgetTotalAmountTranferBank(
                    data: dataNotifier.data.amountInflowTransferBank,
                    title: "Receita por Tranferência Bancária",
                  );
                }),
            ListenableBuilder(
                listenable: dataNotifier,
                builder: (c, w) {
                  // print("AQUI ALTEROU: ${dataNotifier.data}");
                  return ChartsWidgetTotalAmountTranferBank(
                    data: dataNotifier.data.amountOutflowTransferBank,
                    title: "Despesa por Tranferência Bancária",
                  );
                }),
          ],
        ),
      )),
    ));
  }

  _period(context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800.00, maxHeight: 80.00),
      child: Center(
        widthFactor: 800.00,
        child: Flex(
          direction: MediaQuery.of(context).size.width < 375
              ? Axis.vertical
              : Axis.horizontal,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ListenableBuilder(
                listenable: notifier,
                builder: (context, child) {
                  return Flexible(
                      child: SizedBox(
                    width: 250,
                    child: Center(
                      child: Text(
                          "Período: ${Config.dateFormat.format(notifier.dateTimeRange.start)} - ${Config.dateFormat.format(notifier.dateTimeRange.end)}", textAlign: TextAlign.center,),
                    ),
                  ));
                }),
            Flexible(
                child: SizedBox(
              width: 250,
              child: Center(
                child: TextButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      notifier.selectDateRange(context);
                    },
                    label: const Text("Selecionar Período", textAlign: TextAlign.center)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  _balance(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: value < 0
              ? Colors.redAccent.shade400
              : value > 0
                  ? Colors.greenAccent.shade700
                  : Theme.of(context).primaryColorDark,
          shadowColor: Colors.blueGrey,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Saldo",
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Config.currencyFormat.format(value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(60.0),
                            fontWeight: FontWeight.w900),
                        textScaler: MediaQuery.textScalerOf(context)
                            .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                      ),
                    ])),
          ),
        ));
  }

  _balanceInflow(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            // color: Theme.of(context).primaryColorLight,
            shadowColor: Colors.blueGrey,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Receitas",
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Config.currencyFormat.format(value),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize:
                                  MediaQuery.textScalerOf(context).scale(60.0),
                              fontWeight: FontWeight.w900),
                          textScaler: MediaQuery.textScalerOf(context)
                              .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                        ),
                      ])),
            )));
  }

  _balanceOutflow(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColorDark,
          shadowColor: Colors.blueGrey,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Despesas",
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Config.currencyFormat.format(value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(60.0),
                            fontWeight: FontWeight.w900),
                        textScaler: MediaQuery.textScalerOf(context)
                            .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                      ),
                    ])),
          ),
        ));
  }

  _balanceInflowCards(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColorDark,
          shadowColor: Colors.blueGrey,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Receitas Cartão",
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Config.currencyFormat.format(value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(60.0),
                            fontWeight: FontWeight.w900),
                        textScaler: MediaQuery.textScalerOf(context)
                            .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                      ),
                    ])),
          ),
        ));
  }

  _balanceOutflowCards(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColorDark,
          shadowColor: Colors.blueGrey,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Despesas Cartão",
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Config.currencyFormat.format(value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(60.0),
                            fontWeight: FontWeight.w900),
                        textScaler: MediaQuery.textScalerOf(context)
                            .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                      ),
                    ])),
          ),
        ));
  }

  _balanceInflowTransferBank(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColorDark,
          shadowColor: Colors.blueGrey,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Receitas Transferências Bancárias",
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Config.currencyFormat.format(value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(60.0),
                            fontWeight: FontWeight.w900),
                        textScaler: MediaQuery.textScalerOf(context)
                            .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                      ),
                    ])),
          ),
        ));
  }

  _balanceOutflowTransferBank(context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
            minHeight: 156.25,
            minWidth: 250.0)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColorDark,
          shadowColor: Colors.blueGrey,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Despesas Transferências Bancárias",
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Config.currencyFormat.format(value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(60.0),
                            fontWeight: FontWeight.w900),
                        textScaler: MediaQuery.textScalerOf(context)
                            .clamp(minScaleFactor: 0.2, maxScaleFactor: 2.0),
                      ),
                    ])),
          ),
        ));
  }
}
