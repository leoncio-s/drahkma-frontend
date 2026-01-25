
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_get_all.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/domain/usecases/card_get_all.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/usecases/category_get_all.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/data/models/transferbank_model.dart';
import 'package:drahkma/features/item/domain/enums/transfer_bank_type_enum.dart';
import 'package:drahkma/features/item/domain/usecases/item_save.dart';
import 'package:drahkma/features/item/domain/usecases/item_update.dart';
import 'package:drahkma/presentation/styles/input_text_style.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:drahkma/core/config.dart';
import 'package:intl/intl.dart';

class ItemForm extends StatefulWidget {
  final ItemModel? data;
  final bool expense;
  const ItemForm({super.key, this.data, this.expense = true});

  @override
  State<StatefulWidget> createState() => ItemFormState();
}

class ItemFormState extends State<ItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  MoneyMaskedTextController _value = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: "R\$ ");
  final TextEditingController _date = TextEditingController();
  int? _category;
  int? _card;
  bool _transferbank = true;
  // ignore: non_constant_identifier_names
  TransferBankTypeEnum? _transferbank_type;
  // ignore: non_constant_identifier_names
  final TextEditingController _transferbank_description =
      TextEditingController();
  // ignore: non_constant_identifier_names
  int? _transferbank_bank_account;

  // _tran

  DateFormat dateFormat = Config.dateFormat;
  // NumberFormat currencyFormat = Config.currencyFormat;

  List<CategoryModel>? category;
  List<BankAccountModel>? bankAccounts = [];
  List<CardModel>? cards = [];
  dynamic data;
  bool expense = false;

  @override
  void initState() {
    Future.wait([
      getIt<CategoryGetAll>().call(),
      getIt<BankAccountGetAll>().call(),
      getIt<CardGetAll>().call()
    ]).then((value) {
      setState(() {
        category = value[0] as List<CategoryModel>?;
        bankAccounts = value[1] as List<BankAccountModel>?;
        cards = value[2] as List<CardModel>?;
      });
    });

    expense = widget.expense;

    if (widget.data != null) {
      try {
        _description.text = widget.data!.description ?? "";
        expense = widget.data!.expense ?? expense;
        _value = MoneyMaskedTextController(
            initialValue: widget.data!.value ?? 0.00,
            decimalSeparator: ',',
            thousandSeparator: '.',
            leftSymbol: "R\$ ");
        _date.text = dateFormat.format(widget.data?.date ?? DateTime.now());
        _category = widget.data?.category?.id;
        _card = widget.data?.card?.id;
        _transferbank = widget.data?.transferBank != null ? true : false;
        _transferbank_type = widget.data?.transferBank?.type;
        _transferbank_description.text =
            (_transferbank) ? widget.data!.transferBank!.description! : "";
        _transferbank_bank_account = (_transferbank)
            ? widget.data!.transferBank!.bankAccount?.id
            : null;
      } catch (e) {
        rethrow;
      }
    } else {
      _date.text = dateFormat.format(DateTime.now());
      _category = category?.firstOrNull?.id;
      _transferbank_bank_account = bankAccounts!.firstOrNull?.id;
      _card = cards!.firstOrNull?.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _itemsForm(),
      ),
    ));
  }

  Center _itemsForm() {
    return Center(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                clipBehavior: Clip.hardEdge,
                children: [
                  const SizedBox(
                    height: 25.0,
                  ),
                  Title(
                      color: Colors.white,
                      child: Text(
                        "Formulário de cadastro de ${expense == true ? "Despesas" : "Receitas"}",
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(
                    height: 30.0,
                  ),
                  _commonsFields(),
                  _transferbankForm(),
                  _cardsForm(),

                  const SizedBox(
                    height: 30.0,
                  ),

                  _buttons(),
                ],
              ))),
    );
  }

  Widget _commonsFields() {
    return Flex(
      direction: Axis.vertical,
      children: [
        ////// data
        TextFormField(
          controller: _date,
          cursorColor: Colors.white,
          maxLength: 10,
          keyboardType: TextInputType.datetime,
          style: inputTextStyle(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
            TextInputFormatter.withFunction((old, newV) {
              var dateMask = MaskedTextController(mask: "00/00/0000");
              dateMask.updateText(newV.text);
              return newV.copyWith(
                  text: dateMask.text,
                  selection:
                      TextSelection.collapsed(offset: dateMask.text.length));
            })
          ],
          decoration: (const InputDecoration())
              .applyDefaults(Theme.of(context).inputDecorationTheme)
              .copyWith(
                labelText: "Data",
                counterText: "",
                suffixIcon: IconButton(
                    // color: Theme.of(context).hoverColor,
                    color: Colors.white,
                    onPressed: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDatePickerMode: DatePickerMode.day,
                          useRootNavigator: false,
                          barrierDismissible: false,
                          keyboardType: TextInputType.datetime,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 1000)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 1000)),
                          currentDate: DateTime.tryParse(_date.value.text));
                      if (date != null) {
                        _date.text = dateFormat.format(date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today)),
              ),
        ),

        const SizedBox(
          height: 25.0,
        ),

        ///// descrição
        TextFormField(
          controller: _description,
          cursorColor: Colors.white,
          maxLength: 100,
          keyboardType: TextInputType.name,
          style: inputTextStyle(),
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: (const InputDecoration())
              .applyDefaults(Theme.of(context).inputDecorationTheme)
              .copyWith(labelText: "Descrição", counterText: ""),
        ),

        const SizedBox(
          height: 25.0,
        ),

        ////// valor
        TextFormField(
          controller: _value,
          maxLength: 50,
          keyboardType: TextInputType.number,
          style: inputTextStyle(),
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            LengthLimitingTextInputFormatter(50),
          ],
          decoration: (const InputDecoration())
              .applyDefaults(Theme.of(context).inputDecorationTheme)
              .copyWith(labelText: "Valor", counterText: ""),
        ),

        const SizedBox(
          height: 25.0,
        ),

        ///
        /// category
        category == null
            ? const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator.adaptive(),
              )
            : DropdownButtonFormField<int>(
                initialValue: _category,
                decoration: (const InputDecoration())
                    .applyDefaults(Theme.of(context).inputDecorationTheme)
                    .copyWith(labelText: "Categoria", counterText: ""),
                isDense: false,
                isExpanded: true,
                validator: (value) {
                  if (value == null || value.isNegative) {
                    return "Campo obrigatório ou valor inválido";
                  }
                  return null;
                },
                items: category!
                    .map((cat) => DropdownMenuItem<int>(
                          value: cat.id,
                          child: Text(
                            cat.description.toString(),
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val;
                  });
                },
              ),
        const SizedBox(
          height: 25.0,
        ),

        // transferência bancária
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            width: 100,
            child: Text("Cartão", textAlign: TextAlign.end,),
          ),
          SizedBox(
            width: 80,
            // height: 50,
            child: Center(child: _switchTransferCard(),),
          ),
          const SizedBox(
            width: 100,
            child: Text("Transferência Bancária"),
          ),
        ]),

                const SizedBox(
          height: 25.0,
        ),
      ],
    );
  }

  Switch _switchTransferCard() {
    return Switch(
        activeThumbColor: Theme.of(context).colorScheme.secondary,
        activeTrackColor: Theme.of(context).colorScheme.primary,
        inactiveTrackColor: Theme.of(context).colorScheme.primary,
        inactiveThumbColor: Theme.of(context).colorScheme.secondary,
        value: _transferbank,
        onChanged: (value) {
          setState(() {
            _transferbank = value;
          });
        });
  }

  Widget _transferbankForm() {
    return _transferbank
        ? Flex(direction: Axis.vertical, children: [
            DecoratedBox(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Title(
                            title: "Dados da tranferência bancária",
                            color: Colors.white,
                            child: const Text(
                              "Dados da tranferência bancária",
                              style: TextStyle(fontSize: 20.0),
                            )),
                        const SizedBox(
                          height: 30,
                        ),

                        DropdownButtonFormField<TransferBankTypeEnum?>(
                            initialValue: _transferbank_type,
                            decoration: (const InputDecoration())
                                .applyDefaults(
                                    Theme.of(context).inputDecorationTheme)
                                .copyWith(labelText: "Tipo", counterText: ""),
                            items: TransferBankTypeEnum.values
                                .map((tbTypes) =>
                                    DropdownMenuItem<TransferBankTypeEnum?>(
                                      value: tbTypes,
                                      child: Text(
                                        tbTypes.name.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              _transferbank_type = val;
                            }),

                        const SizedBox(
                          height: 25.0,
                        ),

                        /// transfer bank description
                        TextFormField(
                          controller: _transferbank_description,
                          cursorColor: Colors.white,
                          maxLength: 100,
                          keyboardType: TextInputType.name,
                          style: inputTextStyle(),
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            LengthLimitingTextInputFormatter(100),
                          ],
                          decoration: (const InputDecoration())
                              .applyDefaults(
                                  Theme.of(context).inputDecorationTheme)
                              .copyWith(
                                  labelText: "Descrição", counterText: ""),
                        ),

                        const SizedBox(
                          height: 25.0,
                        ),

                        // bank account
                        DropdownButtonFormField<int?>(
                            initialValue: _transferbank_bank_account,
                            decoration: (const InputDecoration())
                                .applyDefaults(
                                    Theme.of(context).inputDecorationTheme)
                                .copyWith(
                                    labelText: "Conta Bancária",
                                    counterText: ""),
                            isDense: false,
                            isExpanded: true,
                            items: bankAccounts!
                                .map((el) => DropdownMenuItem<int?>(
                                      value: el.id,
                                      child: Text(
                                        el.bankName.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              _transferbank_bank_account = val;
                            }),
                      ],
                    )))
          ])
        : const SizedBox(
            height: 0,
          );
  }

  Widget _cardsForm() {
    return !_transferbank
        ? Flex(direction: Axis.vertical, children: [
            DropdownButtonFormField<int?>(
                initialValue: _card,
                decoration: (const InputDecoration())
                    .applyDefaults(Theme.of(context).inputDecorationTheme)
                    .copyWith(labelText: "Cartão", counterText: ""),
                isDense: false,
                isExpanded: true,
                items: cards!
                    .map((el) => DropdownMenuItem<int?>(
                          value: el.id,
                          child: Text(
                            el.brand.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  _card = val;
                }),
          ])
        : const SizedBox(
            height: 0,
          );
  }

  Widget _buttons() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const SizedBox(
        //   height: 40,
        // ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((st) {
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
                if (_formKey.currentState!.validate()) {
                  dynamic ret;
                  if (widget.data?.id != null) {
                    getIt<ItemUpdate>().call(
                      item:
                      ItemDTO(
                        value: _value.numberValue,
                        id: widget.data!.id,
                        description: _description.text,
                        category:
                            category!.firstWhere((el) => el.id == _category),
                        date: dateFormat.parse(_date.text),
                        expense: widget.expense,
                        card: _transferbank
                            ? null
                            : cards!.firstWhere((el) => el.id == _card),
                        transferBank: _transferbank
                            ? TransferBankModel(
                                id: widget.data?.transferBank?.id,
                                bankAccount: bankAccounts?.firstWhere((el) =>
                                    el.id == _transferbank_bank_account),
                                description: _transferbank_description.text,
                                type: _transferbank_type)
                            : null));
                    // ret = null;
                  } else {
                    
                    ret = await getIt<ItemSave>().call(
                      item: 
                      ItemDTO(
                        card: _transferbank
                            ? null
                            : cards?.firstWhere((el) => el.id == _card),
                        description: _description.text,
                        date: dateFormat.parse(_date.text),
                        value: _value.numberValue,
                        category:
                            category!.firstWhere((el) => el.id == _category),
                        expense: expense,
                        transferBank: _transferbank
                            ? TransferBankModel(
                                bankAccount: bankAccounts?.firstWhere((el) =>
                                    el.id == _transferbank_bank_account),
                                description: _transferbank_description.text,
                                type: _transferbank_type)
                            : null));
                  }

                  if (ret is ItemModel) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, ret);
                  } else {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        ret['errors'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      showCloseIcon: true,
                      backgroundColor: Colors.red,
                      closeIconColor: Colors.white,
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: const Text("Salvar")),
        )
      ],
    );
  }
}
