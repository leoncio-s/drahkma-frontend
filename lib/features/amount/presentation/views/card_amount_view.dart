import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/amount/domain/usecases/amount_fetchdata.dart';
import 'package:flutter/material.dart';

class CardAmountView extends StatefulWidget {
  const CardAmountView({super.key});

  @override
  State<StatefulWidget> createState() => _CardAmountViewState();
}

class _CardAmountViewState extends State<CardAmountView> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ConstrainedBox(
      constraints: const BoxConstraints(
          minHeight: 50, maxHeight: 200, minWidth: 50, maxWidth: 200),
      child: Center(
        child: FutureBuilder(
            future: getIt<AmountsFetchdata>().call(
                DateTime.now().subtract(const Duration(days: 30)),
                DateTime.now()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Flexible(
                    child: Card.outlined(
                  child: Text(snapshot.data.toString()),
                ));
              }
              return const CircularProgressIndicator();
            }),
      ),
    ));
  }
}
