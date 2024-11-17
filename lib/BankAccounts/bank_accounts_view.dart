import 'dart:async';

import 'package:flutter/material.dart';
import 'package:drahkma/BankAccounts/bank_accounts_dto.dart';
import 'package:drahkma/BankAccounts/bank_accounts_form.dart';
import 'package:drahkma/BankAccounts/bank_accounts_service.dart';
import 'package:drahkma/Utils/text_scaler.dart';
import 'package:drahkma/commonsComponents/statefullwidget.dart';

class BankAccountsView extends StatefulwidgetDrahkma {
  const BankAccountsView(
      {super.name = "Contas Bancárias",
      super.icon = const Icon(Icons.category, size: 20)});

  @override
  State<BankAccountsView> createState() => BankAccountsViewState();
}

class BankAccountsViewState extends State<BankAccountsView> {
  List<BankAccountsDto>? bank_accounts;
  String? _message;
  double _turns = 0.0;

  _getData() {
    return BankAccountsService().get().then((value) {
      if(mounted){
        setState(() {
        bank_accounts = value;
        _message = null;
      });
      }
    }).onError((e, s) {
      if(mounted){
        setState(() {
        _message = "Erro ao processar solicitação. Tente novamente!";
      });
      }
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  // @override
  // void dispose() {
  //   // _timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Flex(
            direction: Axis.vertical,
            children: [
              const SizedBox(
                height: 30,
              ),
              MediaQuery.of(context).size.width < 500 ? Text(
                "Contas bancárias",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(
                    principalCardScaller(MediaQuery.of(context).size.width)),
              ) : const SizedBox(),
              bank_accounts != null && bank_accounts!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Ordem Crescente",
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  bank_accounts!.sort(BankAccountsSort.asc);
                                });
                              },
                              icon: const Icon(Icons.arrow_upward)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Tooltip(
                          message: "Ordem Decrescente",
                          child: IconButton(
                              onPressed: () {
                                bank_accounts != null
                                    ? setState(() {
                                        bank_accounts!
                                            .sort(BankAccountsSort.desc);
                                      })
                                    : null;
                              },
                              icon: const Icon(Icons.arrow_downward)),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              listTileCategories()
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            BankAccountsDto? data = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BankAccountsForm()));
            if (data != null) {
              _getData();
            }
          },
          label: const Text("Adicionar Banco")),
    );
  }

  Widget listTileCategories() {
    return bank_accounts != null
        ? Column(
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            // padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            children: ListTile.divideTiles(
                    context: context,
                    tiles: bank_accounts!
                        .map((el) => ListTile(
                              title: Text(el.bankName.toString()),
                              subtitle: Text(
                                  "Agencia: ${el.agency}  Conta: ${el.accountNumber}"),
                              contentPadding: const EdgeInsets.all(5),
                              titleAlignment: ListTileTitleAlignment.center,
                              onTap: () async {
                                BankAccountsDto? data =
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BankAccountsForm(
                                                    bankAccounts: el)));
                                if (data != null) {
                                  _getData();
                                }
                              },
                              trailing: IconButton(
                                  splashRadius: 20.0,
                                  // visualDensity: const VisualDensity(horizontal: 0.0),
                                  hoverColor: Colors.white,
                                  onPressed: () async {
                                    dynamic ret =
                                        await BankAccountsService().delete(el);
                                    if (ret == true) {
                                      _getData();
                                    } else {
                                      if (context.mounted) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                _snackBarError(ret['error']));
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ))
                        .toList())
                .toList())
        : _message == null
            ? SizedBox.fromSize(
                size: const Size(50, 50),
                child: const CircularProgressIndicator())
            : Center(
                child: _replayData(),
              );
  }

  _snackBarError(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      showCloseIcon: true,
    );
  }

  _replayData() {
    return SizedBox.fromSize(
        size: const Size.fromHeight(100.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
                child: Text(
                    _message!.isEmpty ? "Erro ao processar dados" : _message!)),
            const SizedBox(
              height: 30,
            ),
            Flexible(
                child: Tooltip(
                    message: "Tentar Novamente",
                    child: IconButton.filled(
                        onPressed: () {
                          setState(() {
                            _turns -= 1.0;
                            _message = null;
                          });
                          _getData();
                        },
                        icon: AnimatedRotation(
                          turns: _turns,
                          duration: const Duration(seconds: 1),
                          child: const Icon(Icons.replay),
                        ))))
          ],
        ));
  }
}
