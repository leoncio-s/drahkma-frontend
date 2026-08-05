import 'package:drahkma/core/utils/helpers/currency_brl_format.dart';
import 'package:drahkma/features/bank_account/presentation/widgets/amount_bank_accounts_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  testWidgets("should display a negative value", (WidgetTester test) async{
    double negativeValue = -100.20;
    await test.pumpWidget(MaterialApp(home: Scaffold(body: AmountBankAccountsCard(value: negativeValue),),));

    expect(find.byKey(ValueKey("amount_bank_account_card")), findsOneWidget);

    final finder = find.byKey(ValueKey("value_amount_bank_account_card"));

    expect(finder, findsOne);

    final textWidget = test.widget<Text>(finder);

    expect(textWidget.data, currencyBRLFormat(negativeValue));
    test.pump();
  });

  testWidgets("should display a positive value", (WidgetTester test) async{
    double negativeValue = 10310.20;
    await test.pumpWidget(MaterialApp(home: Scaffold(body: AmountBankAccountsCard(value: negativeValue),),));

    expect(find.byKey(ValueKey("amount_bank_account_card")), findsOneWidget);

    final finder = find.byKey(ValueKey("value_amount_bank_account_card"));

    expect(finder, findsOne);

    final textWidget = test.widget<Text>(finder);

    expect(textWidget.data, currencyBRLFormat(negativeValue));
    test.pump();
  });

  testWidgets("should display a zero value", (WidgetTester test) async{
    double negativeValue = 0.00;
    await test.pumpWidget(MaterialApp(home: Scaffold(body: AmountBankAccountsCard(value: negativeValue),),));

    expect(find.byKey(ValueKey("amount_bank_account_card")), findsOneWidget);

    final finder = find.byKey(ValueKey("value_amount_bank_account_card"));

    expect(finder, findsOne);

    final textWidget = test.widget<Text>(finder);

    expect(textWidget.data, currencyBRLFormat(negativeValue));
    test.pump();
  });
}