import 'dart:math';

import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:flutter/material.dart';

class BankAccountCard extends StatelessWidget {
  final Function()? onEdit;
  final Function()? onDelete;
  final BankAccount bankAccount;
  const BankAccountCard({super.key, required this.bankAccount, this.onEdit, this.onDelete});
  @override
  Widget build(BuildContext context) => Card(
        shadowColor: AppColors.lightGold,
        clipBehavior: Clip.hardEdge,
        key: const ValueKey("bank_account_card"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 80, maxHeight: 300, minWidth: 80, maxWidth: 200),
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 2.0,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.account_balance_sharp,
                            size: 30,
                            color: randomMaterialColor(),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                style: ButtonStyle(
                                    alignment: Alignment.center,
                                    overlayColor: WidgetStatePropertyAll(
                                        Colors.transparent),
                                    iconColor: WidgetStateColor.fromMap({
                                      WidgetState.hovered: AppColors.lightGold,
                                      WidgetState.any: AppColors.gold,
                                    })),
                                onPressed: onEdit,
                                icon: Icon(Icons.edit),
                                padding: EdgeInsets.zero,
                                iconSize: 25.0,
                              ),
                              IconButton(
                                style: ButtonStyle(
                                    alignment: Alignment.center,
                                    overlayColor: WidgetStatePropertyAll(
                                        Colors.transparent),
                                    iconColor: WidgetStateColor.fromMap({
                                      WidgetState.hovered: const Color.fromARGB(
                                          255, 255, 172, 194),
                                      WidgetState.any: AppColors.redError,
                                    })),
                                onPressed: onDelete,
                                icon: Icon(Icons.delete),
                                padding: EdgeInsets.zero,
                                iconSize: 25.0,
                              ),
                            ],
                          ),
                        ]),
                  ),
                  // Flexible(child: SizedBox(height: 10)),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankAccount.bankName ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                          overflow: TextOverflow.ellipsis,
                          textScaler: TextScaler.linear(1.2),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10,),
                        Text("AGÊNCIA: ${bankAccount.agency ?? ""}",
                            textAlign: TextAlign.left),
                        Text("CONTA: ${bankAccount.accountNumber ?? ""}",
                            textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                  Flexible(child: Divider(color: AppColors.gold.withAlpha(50),),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Saldo do período:"),
                      Text("R\$ ", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.gold,), textScaler: TextScaler.linear(1.5),)
                    ],
                  )
                ],
              ),
            )),
      );

  MaterialColor randomMaterialColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
