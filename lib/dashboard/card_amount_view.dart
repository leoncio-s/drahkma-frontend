import 'package:flutter/material.dart';
import 'package:front_lfinanca/Dashboard/dash_services.dart';

class CardAmountView extends StatefulWidget {
  CardAmountView({super.key});

  @override
  State<StatefulWidget> createState() => _cardAmountViewState();
}

class _cardAmountViewState extends State<CardAmountView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: ConstrainedBox(
      constraints: const BoxConstraints(
          minHeight: 50, maxHeight: 200, minWidth: 50, maxWidth: 200),
      child: Center(
        child: FutureBuilder(
            future: DashServices().getAmounts(
                DateTime.now().subtract(const Duration(days: 30)), DateTime.now()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Flexible(
                    child: Card.outlined(
                  child: Text(snapshot.data.toString()),
                ));
              }
              return CircularProgressIndicator();
            }),
      ),
    ));
  }
}
