import 'dart:ui';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/presentation/notifiers/app_notifier.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/presentation/controllers/amount_controller.dart';
import 'package:drahkma/features/amount/presentation/widgets/charts_total_amount_widget.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';

class DashboardAmountView extends DrahkmaStatefulWidget{
  final AmountController amountController;
  const DashboardAmountView(
      {
        required this.amountController,
        super.key,
        super.name = "Dashboard",
        super.icon = const Icon(Icons.dashboard, size: 20),});

  @override
  State<DashboardAmountView> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardAmountView> {
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
      amountController: widget.amountController,
    )
        );
  }
}


class _Cards extends StatefulWidget
{
  final AppNotifier notifier;
  final AmountController amountController;
  const _Cards({required this.notifier, required this.amountController});

  @override
  State<_Cards> createState() => _CardsState();
  
}


class _CardsState extends State<_Cards> {
  late DashboardModel data;
  late AppNotifier notifier;

  void _onTimerListener() async{
      await widget.amountController.loadAmounts(start: notifier.dateTimeRange.start, end: notifier.dateTimeRange.end);
      // setState(() {
        data = widget.amountController.data!;
      // });
  }

  @override
  void initState() {
    super.initState();
    notifier = widget.notifier;
    notifier.addListener(_onTimerListener);
    data = widget.amountController.data!;
    _onTimerListener();
  }

  @override
  void dispose() {
    super.dispose();
    notifier.removeListener(_onTimerListener);
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
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balance(context, data.amount);
                }),

            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balanceInflow(context, data.inflow);
                }),

            
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balanceOutflow(context, data.outflow);
                }),
            
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balanceInflowCards(
                      context, data.totalAmountInflowCards);
                }),
            
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balanceOutflowCards(
                      context, data.totalAmountOutflowCards);
                }),
            
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balanceInflowTransferBank(
                      context, data.totalAmountInflowTransferBank);
                }),
            
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return _balanceOutflowTransferBank(context,
                      data.totalAmountOutflowTransferBank);
                }),
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return ChartTotalAmountWidget(
                    data: data.amountInflowCategory,
                    title: "Receitas por Categoria",
                  );
                }),
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return ChartTotalAmountWidget(
                    data: data.amountInflowCard,
                    title: "Receitas por Cartão",
                  );
                }),
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return ChartTotalAmountWidget(
                    data: data.amountOutflowCategory,
                    title: "Despesas por Categoria",
                  );
                }),
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return ChartTotalAmountWidget(
                    data: data.amountOutflowCard,
                    title: "Despesas por Cartão",
                  );
                }),
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return ChartsWidgetTotalAmountTranferBank(
                    data: data.amountInflowTransferBank,
                    title: "Receita por Tranferência Bancária",
                  );
                }),
            ListenableBuilder(
                listenable: widget.amountController,
                builder: (c, w) {
                  return ChartsWidgetTotalAmountTranferBank(
                    data: data.amountOutflowTransferBank,
                    title: "Despesa por Tranferência Bancária",
                  );
                }),
          ],
        ),
      )),
    ));
  }

  Widget _period(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800.00, maxHeight: 80.00),
      child: Center(
        widthFactor: 800.00,
        child: Flex(
          direction: MediaQuery.of(context).size.width < 375
              ? Axis.vertical
              : Axis.horizontal,
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
                    icon: const Icon(Icons.calendar_month, color:AppColors.gold,),
                    onPressed: () async {
                      notifier.selectDateRange(context);
                    },
                    label: const Text("Selecionar Período", textAlign: TextAlign.center, style: TextStyle(color: AppColors.gold),)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _balance(BuildContext context, double value) {
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

  Widget _balanceInflow(BuildContext context, double value) {
    return ConstrainedBox(
        constraints: BoxConstraints.fromViewConstraints(const ViewConstraints(
            maxWidth: 400.0,
            maxHeight: 250.0,
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

  Widget _balanceOutflow(BuildContext context, double value) {
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

  Widget _balanceInflowCards(BuildContext context, double value) {
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

  Widget _balanceOutflowCards(BuildContext context, double value) {
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

  Widget _balanceInflowTransferBank(BuildContext context, double value) {
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

  Widget _balanceOutflowTransferBank(BuildContext context, double value) {
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
