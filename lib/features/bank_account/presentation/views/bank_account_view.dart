import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:drahkma/features/bank_account/presentation/controllers/bank_account_controller.dart';
import 'package:drahkma/features/bank_account/presentation/widgets/amount_bank_accounts_card.dart';
import 'package:drahkma/features/bank_account/presentation/widgets/bank_account_card.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/bank_account/presentation/forms/bank_account_form.dart';

class BankAccountView extends DrahkmaStatefulWidget {
  final BankAccountController bankAccountController;
  const BankAccountView(
      {super.key,
      super.name = "Contas Bancárias",
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
      if (state is BankAccountLoaded) {
        setState(() {
          bankAccounts = widget.bankAccountController.data;
          _message = null;
        });
      } else if (state is AppStateError) {
        setState(() {
          _message = state.message ??
              "Erro ao processar solicitação. Tente novamente!";
        });
        _replayData();
      } else if (state is BankAccountLoading) {
        setState(() {
          _message = null;
        });
      } else if (state is Unauthenticated) {
        if (mounted) {
          WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          });
        }
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
      floatingActionButton: MediaQuery.of(context).size.width <= 710 ? 
              FloatingActionButton
              (
                  onPressed: _addNewAccount, 
                  // label: const Text("Adicionar Nova Conta"), 
                  backgroundColor: AppColors.gold, 
                  mouseCursor: WidgetStateMouseCursor.clickable,
                  heroTag: "add_new_bank_account",
                  tooltip: "Adicionar Nova Conta",
                  child: Icon(Icons.add),
                  ) 
              : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: LayoutBuilder(
          builder: (context, _) => Column(
            children: [
              const SizedBox(height: 10.0),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity, minHeight: 50),
                // direction: Axis.horizontal,
                child: Wrap(
                        spacing: 5.0,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Wrap(
                            // mainAxisSize: MainAxisSize.max,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            children: [
                              const Text(
                                "Minhas Contas",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                                textScaler: TextScaler.linear(1.2),
                                textAlign: TextAlign.left,
                              ),
                              const Text(
                                "Gerência suas contas bancárias para um melhor controle financeiro",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                                textScaler: TextScaler.linear(1.2),
                              ),
                            ],
                          ),
                          MediaQuery.of(context).size.width > 710 ? ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            onPressed: _addNewAccount,
                            style: ButtonStyle(
                                minimumSize:
                                    WidgetStatePropertyAll(Size(150, 60)),
                                maximumSize:
                                    WidgetStatePropertyAll(Size(350, 120)),
                                iconAlignment: IconAlignment.start,
                                backgroundColor: WidgetStateProperty.fromMap({
                                  WidgetState.hovered:
                                      AppColors.gold.withAlpha(200),
                                  WidgetState.any: AppColors.gold
                                }),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(
                                                10.0))),
                                mouseCursor: WidgetStateMouseCursor.clickable),
                            label: const Text("Adicionar Nova Conta"),
                          ) : SizedBox()
                        ],
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              AmountBankAccountsCard(value: 1000,),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 200, minWidth: double.infinity),
                child: Wrap(
                    alignment: MediaQuery.of(context).size.width < 500 ? WrapAlignment.center : WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: bankAccounts != null
                        ? bankAccounts!
                            .map((el) => BankAccountCard(
                                  bankAccount: el,
                                  onDelete: () async => _onDelete(el),
                                  onEdit: () async => _onEdit(el),
                                ))
                            .toList()
                        : [],
                  )
                ,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onEdit(BankAccountModel banckAccount) async {
    BankAccountModel? data = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BankAccountForm(
              bankAccounts: banckAccount,
              bankAccountController: widget.bankAccountController,
            )));
    if (data != null) {
      _loadData();
    }
  }

  Future<void> _addNewAccount() async 
  {
      BankAccountModel? data =
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => BankAccountForm(
                        bankAccountController: widget
                            .bankAccountController,
                      )));
      if (data != null) {
        _loadData();
      }
    }

  Future<void> _onDelete(BankAccountModel bankAccount) async {
    await widget.bankAccountController
        .deleteBankAccount(BankAccountMapper.fromEntityToDTO(bankAccount));
    if (_message != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_snackBarError(_message!));
      }
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(_snackBarError("Item excluido com sucesso"));
    }
    return;
  }

  SnackBar _snackBarError(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.redError,
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
