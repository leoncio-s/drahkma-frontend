import 'package:drahkma/features/amount/presentation/controllers/amount_controller.dart';
import 'package:flutter/material.dart';

class CardAmountView extends StatefulWidget {
  final AmountController amountController;
  const CardAmountView({super.key, required this.amountController});

  @override
  State<StatefulWidget> createState() => _CardAmountViewState();
}

class _CardAmountViewState extends State<CardAmountView> {
  @override
  void initState() {
    super.initState();
    widget.amountController.loadAmounts(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ConstrainedBox(
      constraints: const BoxConstraints(
          minHeight: 50, maxHeight: 200, minWidth: 50, maxWidth: 200),
      child: Center(
        child: ListenableBuilder(
          listenable: widget.amountController,
          builder: (context, child) {
            if (widget.amountController.value is AmountsLoaded) {
              return Flexible(
                  child: Card.outlined(
                child: Text('Dados carregados'),
              ));
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    ));
  }
}
