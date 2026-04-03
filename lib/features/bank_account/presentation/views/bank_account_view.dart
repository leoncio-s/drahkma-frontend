import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/utils/bank_account_sort.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:drahkma/features/bank_account/presentation/controllers/bank_account_controller.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/bank_account/presentation/forms/bank_account_form.dart';

class BankAccountView extends DrahkmaStatefulWidget {
  final BankAccountController bankAccountController;
  const BankAccountView(
      {super.key, super.name = "Contas Bancárias",
      super.icon = const Icon(Icons.category, size: 20),
      required this.bankAccountController});

  @override
  State<BankAccountView> createState() => BankAccountsViewState();
}

class BankAccountsViewState extends State<BankAccountView> {
  List<BankAccountModel>? bankAccounts;
  String? _message;
  double _turns = 0.0;

  void _loadData() {
    widget.bankAccountController.loadBankAccounts();
  }

  void _onControllerStateChanged() {
    if (mounted) {
      final state = widget.bankAccountController.value;
      if (state is BankAccountsLoaded) {
        setState(() {
          bankAccounts = state.data;
          _message = null;
        });
      } else if (state is AppStateError) {
        setState(() {
          _message = state.message ?? "Erro ao processar solicitação. Tente novamente!";
        });
      } else if (state is AppStateLoading) {
        setState(() {
          _message = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    widget.bankAccountController.addListener(_onControllerStateChanged);
  }

  @override
  void dispose() {
    widget.bankAccountController.removeListener(_onControllerStateChanged);
    super.dispose();
  }


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
              bankAccounts != null && bankAccounts!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Ordem Crescente",
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  bankAccounts!.sort(BankAccountSort.asc);
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
                                bankAccounts != null
                                    ? setState(() {
                                        bankAccounts!
                                            .sort(BankAccountSort.desc);
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
              listTileCategory()
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            BankAccountModel? data = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BankAccountForm()));
            if (data != null) {
              _loadData();
            }
          },
          label: const Text("Adicionar Banco")),
    );
  }

  Widget listTileCategory() {
    return bankAccounts != null
        ? Column(
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            // padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            children: ListTile.divideTiles(
                    context: context,
                    tiles: bankAccounts!
                        .map((el) => ListTile(
                              title: Text(el.bankName.toString()),
                              subtitle: Text(
                                  "Agencia: ${el.agency}  Conta: ${el.accountNumber}"),
                              contentPadding: const EdgeInsets.all(5),
                              titleAlignment: ListTileTitleAlignment.center,
                              onTap: () async {
                                BankAccountModel? data =
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BankAccountForm(
                                                    bankAccounts: el)));
                                if (data != null) {
                                  _loadData();
                                }
                              },
                              trailing: IconButton(
                                  splashRadius: 20.0,
                                  hoverColor: Colors.white,
                                  onPressed: () async {
                                    dynamic ret = false;
                                    await widget.bankAccountController.deleteBankAccount(el);
                                    if (ret == true) {
                                      _loadData();
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

  SnackBar _snackBarError(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      showCloseIcon: true,
    );
  }

  Widget _replayData() {
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
                          _loadData();
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
