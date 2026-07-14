import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AmountBankAccountsCard extends StatelessWidget {
  const AmountBankAccountsCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
      shadowColor: AppColors.lightGold,
      clipBehavior: Clip.hardEdge,
      key: const ValueKey("amount_bank_account_card"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 80,
            maxHeight: 150,
            minWidth: 100,
            maxWidth: double.infinity),
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8.0),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "SALDO TOTAL",
                      style: TextStyle(
                        fontSize: responsiveFontSize(context, min: 16, max: 20),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "R\$",
                      style: TextStyle(
                        fontSize: responsiveFontSize(context, min: 13, max: 15),
                      ),
                    ),
                    Text(
                      "1.000,00",
                      style: TextStyle(
                        fontSize: responsiveFontSize(
                          context,
                          factor: 0.10,
                          min: 28,
                          max: 40,
                        ),
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: responsiveTextScaler(context),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ));
}
