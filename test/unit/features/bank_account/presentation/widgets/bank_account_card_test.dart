// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/presentation/widgets/bank_account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test Bank Account Card elements', (WidgetTester tester) async {

    BankAccount bankAccount = BankAccount(id: 1, bankName: "Banco do Brasil", bankCode: "001", agency: "1234", accountNumber: "56789-0");
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: 
      Scaffold(body: 
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700, maxHeight: 700),
          child: BankAccountCard(bankAccount: bankAccount),
        )
      )));

    
    expect(find.byKey(ValueKey("bank_account_card")), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    expect(find.text(bankAccount.bankName??""), findsOne);
    expect(find.text("AGÊNCIA: ${bankAccount.agency ?? ""}"), findsOne);
    expect(find.text("CONTA: ${bankAccount.accountNumber ?? ""}"), findsOne);

    await tester.pump();
  });

  testWidgets("test action on click edit button", (WidgetTester tester) async {
      BankAccount bankAccount = BankAccount(id: 1, bankName: "Banco do Brasil", bankCode: "001", agency: "1234", accountNumber: "56789-0");
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: BankAccountCard(bankAccount: bankAccount))));
  
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();
  
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();
  });
}
