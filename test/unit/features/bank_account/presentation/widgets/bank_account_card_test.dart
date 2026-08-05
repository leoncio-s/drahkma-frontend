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
  testWidgets('should render the single BankAccountCard widget', (WidgetTester tester) async {
    BankAccount bankAccount = BankAccount(
        id: 1,
        bankName: "Banco do Brasil",
        bankCode: "001",
        agency: "1234",
        accountNumber: "56789-0");
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: BankAccountCard(bankAccount: bankAccount),
    )));

    expect(find.byKey(ValueKey("bank_account_card")), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    expect(find.text(bankAccount.bankName ?? ""), findsOne);
    expect(find.text("AGÊNCIA: ${bankAccount.agency ?? ""}"), findsOne);
    expect(find.text("CONTA: ${bankAccount.accountNumber ?? ""}"), findsOne);

    await tester.pump();
  });

  testWidgets("should trigger the onEdit action when the edit button is pressed", (WidgetTester tester) async {
    BankAccount bankAccount = BankAccount(
        id: 1,
        bankName: "Banco do Brasil",
        bankCode: "001",
        agency: "1234",
        accountNumber: "56789-0");

    bool pressed = false;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: BankAccountCard(
      bankAccount: bankAccount,
      onEdit: () {
        pressed = true;
      },
    ))));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    expect(pressed, true);
  });

  testWidgets("should trigger the onDelete action when the edit button is pressed", (WidgetTester tester) async {
    BankAccount bankAccount = BankAccount(
        id: 1,
        bankName: "Banco do Brasil",
        bankCode: "001",
        agency: "1234",
        accountNumber: "56789-0");

    bool pressed = false;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: BankAccountCard(
      bankAccount: bankAccount,
      onDelete: () {
        pressed = true;
      },
    ))));

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(pressed, true);
  });

  testWidgets('should render the multiple BankAccountCard widget', (WidgetTester tester) async {
    List<BankAccount> bankAccount = [
        BankAccount(
          id: 1,
          bankName: "Banco do Brasil",
          bankCode: "001",
          agency: "1234",
          accountNumber: "56789-0"),
        BankAccount(
          id: 2,
          bankName: "Banco Itau",
          bankCode: "341",
          agency: "4321",
          accountNumber: "123455-0"),
        BankAccount(
          id: 3,
          bankName: "Banco Bradesco",
          bankCode: "999",
          agency: "9999",
          accountNumber: "999999")
        ];
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Wrap(children: bankAccount.map((bank)=>BankAccountCard(bankAccount: bank)).toList(),),
    )));

    expect(find.byKey(ValueKey("bank_account_card")), findsNWidgets(bankAccount.length));
    expect(find.byIcon(Icons.edit), findsNWidgets(bankAccount.length));
    expect(find.byIcon(Icons.delete), findsNWidgets(bankAccount.length));

    await tester.pump();
  });
}
