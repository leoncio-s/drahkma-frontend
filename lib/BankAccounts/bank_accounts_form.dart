import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drahkma/BankAccounts/bank_accounts_dto.dart';
import 'package:drahkma/BankAccounts/bank_accounts_service.dart';
import 'package:drahkma/BankAccounts/banks_dto.dart';
import 'package:drahkma/Utils/string_regex_validate.dart';
import 'package:drahkma/commonsComponents/input_text_style.dart';

// ignore: must_be_immutable
class BankAccountsForm extends StatefulWidget {
  BankAccountsDto? bankAccounts;
  BankAccountsForm({super.key, this.bankAccounts});

  @override
  State<BankAccountsForm> createState() => BankAccountsStateForm();
}

class BankAccountsStateForm extends State<BankAccountsForm> {
  final GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController _bankName = TextEditingController();
  final TextEditingController _bankCode = TextEditingController();
  final TextEditingController _agency = TextEditingController();
  final TextEditingController _accountNumber = TextEditingController();
  List<BanksDto> _banks = [];

  _getBanks() async {
    var banks = await BankAccountsService().getBanks();
    if (banks != null) {
      setState(() {
        _banks = banks;
      });
    }
  }

  static String _displayStringForBanksOption(BanksDto bank) => bank.fullName ?? "";

  @override
  void initState() {
    _getBanks();
    if (widget.bankAccounts != null) {
      _bankName.text = widget.bankAccounts!.bankName ?? "";
      _bankCode.text = widget.bankAccounts!.bankCode.toString();
      _agency.text = widget.bankAccounts!.agency.toString();
      _accountNumber.text = widget.bankAccounts!.accountNumber.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: _form(),
    ));
  }

  _form() {
    return Center(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Form(
          key: _formState,
          child: Column(
            // direction: Axis.vertical,
            // textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              Title(
                  color: Colors.white,
                  child: Text(widget.bankAccounts != null
                      ? "Atualizar Dados bancários"
                      : "Adicionar Dados bancários")),
              const SizedBox(height: 50.0),

              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 70.0),
                child: Autocomplete<BanksDto>(
                  displayStringForOption: _displayStringForBanksOption,
                  initialValue: _bankName.value,
                  fieldViewBuilder: (context, controller, focusNode,
                          onFieldSubmitted) =>
                      TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    controller: controller,
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    cursorColor: Colors.white,
                    maxLength: 100,
                    keyboardType: TextInputType.name,
                    style: inputTextStyle(),
                    selectionHeightStyle: BoxHeightStyle.includeLineSpacingTop,
                    inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    LengthLimitingTextInputFormatter(100),
                    ],
                    // decoration: const InputDecoration(
                    //     // isCollapsed: true,
                    //     labelText: "Nome do banco",
                    //     counterText: ""),
                    decoration: (const InputDecoration()).applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
                      labelText: "Nome do banco",
                      contentPadding: const EdgeInsets.all(15.0),
                      counterText: ""
                    ),
                    validator: (value) {
                      if (value!.length < 3 || value.length > 100) {
                        return "O tamano minimo é 1 e o máximo é 100";
                      } else if (RegExp(r"[\w\s]+").hasMatch(value) &&
                          StringValidators.sqlInjection(value)) {
                        return "O campo possui caracteres ou expressões inválidas";
                      }
                      setState(() {
                        _bankName.text = value;
                      });
                      return null;
                    },
                  ),
                  optionsBuilder: (TextEditingValue txt) async {
                    if (txt.text == "") {
                      return await BankAccountsService().getBanks() ?? Iterable<BanksDto>.generate(1, (int i)=>BanksDto(null, 'Itau', 341, 'BCO Itau S.A'));
                    }
                    return _banks.where((BanksDto? obj) =>
                        obj!.fullName.toString().toUpperCase().contains(txt.text.toUpperCase()));
                  },
                  onSelected: (BanksDto? bank) {
                    setState(() {
                      _bankCode.text = bank!.code.toString();
                      _bankName.text = bank.fullName!;
                    });
                  },
                ),
              ),

              // ConstrainedBox(
              //   constraints: const BoxConstraints(maxHeight: 70.0),
              //   child: ,
              // ),

              const SizedBox(height: 20.0),

              //// bank code
              ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 70.0),
                  child: TextFormField(
                    autocorrect: true,
                    controller: _bankCode,
                    cursorColor: Colors.white,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    style: inputTextStyle(),
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]{1,10}"))
                    ],
                    // decoration: const InputDecoration(
                    //     labelText: "Código do Banco", counterText: ""),
                    decoration: (const InputDecoration()).applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
                      labelText: "Código do Banco",
                      contentPadding: const EdgeInsets.all(15.0),
                      counterText: ""
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length > 10) {
                        return "O tamano minimo é 1 e o máximo é 10";
                      } else if (RegExp(r"[0-9]{1,10}").hasMatch(value) &&
                          StringValidators.sqlInjection(value)) {
                        return "O campo possui caracteres ou expressões inválidas";
                      }
                      return null;
                    },
                  )),

              const SizedBox(height: 20.0),
              //// agency
              ///
              ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 70.0),
                  child: TextFormField(
                    autocorrect: true,
                    controller: _agency,
                    cursorColor: Colors.white,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    style: inputTextStyle(),
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      LengthLimitingTextInputFormatter(8),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]{1,8}"))
                    ],
                    decoration: (const InputDecoration()).applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
                      labelText: "Agencia",
                      contentPadding: const EdgeInsets.all(15.0),
                      counterText: ""
                    ),
                    // decoration: const InputDecoration(
                    //     labelText: "Agencia", counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty || value.length > 8) {
                        return "O tamano minimo é 3 e o máximo é 8";
                      } else if (RegExp(r"[0-9]{1,8}").hasMatch(value) &&
                          StringValidators.sqlInjection(value)) {
                        return "O campo possui caracteres ou expressões inválidas";
                      }
                      return null;
                    },
                  )),

              const SizedBox(height: 20.0),
              /// account number
              ///
              ///
              ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 70.0),
                  child: TextFormField(
                    autocorrect: true,
                    controller: _accountNumber,
                    cursorColor: Colors.white,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    style: inputTextStyle(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]{1,10}"))
                    ],
                    decoration: (const InputDecoration()).applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
                      labelText: "Número da Conta",
                      contentPadding: const EdgeInsets.all(15.0),
                      counterText: ""
                    ),
                    validator: (value) {
                      if (value!.length < 2 || value.length > 10) {
                        return "O tamano minimo é 2 e o máximo é 10";
                      } else if (RegExp(r"[0-9]{2,10}").hasMatch(value) &&
                          StringValidators.sqlInjection(value)) {
                        return "O campo possui caracteres ou expressões inválidas";
                      }
                      return null;
                    },
                  )),

              const SizedBox(height: 20.0),

              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((st) {
                          return Colors.red;
                        })),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formState.currentState!.validate()) {
                            dynamic ret;
                            if (widget.bankAccounts?.id != null) {
                              ret = await BankAccountsService().update(
                                  BankAccountsDto(
                                      id: widget.bankAccounts!.id,
                                      bankCode: _bankCode.text,
                                      bankName: _bankName.text,
                                      agency: _agency.text,
                                      accountNumber: _accountNumber.text));
                            } else {
                              ret = await BankAccountsService().save(
                                  BankAccountsDto(
                                      bankCode: _bankCode.text,
                                      bankName: _bankName.text,
                                      agency: _agency.text,
                                      accountNumber: _accountNumber.text));
                            }
                            if (ret is BankAccountsDto) {
                              Navigator.pop(context, ret);
                            } else {
                              // print(ret);
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  ret['errors'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                showCloseIcon: true,
                                backgroundColor: Colors.red,
                                closeIconColor: Colors.white,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        child: const Text("Salvar")),
                  )
                ],
              )
            ],
          )),
    ));
  }
}
