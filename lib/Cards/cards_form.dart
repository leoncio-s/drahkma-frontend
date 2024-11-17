import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drahkma/Cards/cards_dto.dart';
import 'package:drahkma/Cards/cards_flags_enum.dart';
import 'package:drahkma/Cards/cards_services.dart';
import 'package:drahkma/Cards/cards_type_enum.dart';
import 'package:drahkma/Utils/months.dart';
import 'package:drahkma/Utils/string_regex_validate.dart';
import 'package:drahkma/commonsComponents/input_text_style.dart';

// ignore: must_be_immutable
class CardsForm extends StatefulWidget {
  CardsDto? cards;
  CardsForm({super.key, this.cards});

  @override
  State<CardsForm> createState() => CardsStateForm();
}

class CardsStateForm extends State<CardsForm> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _brand = TextEditingController();
  // final MaskedTextController _expiresAt = MaskedTextController(
  //   mask: '00/00',
  // );
  // DateTime? _expiresAt;
  Months? _expMonth =
      Months.values.firstWhere((el) => DateTime.now().month == el.month);
  int? _expYear = DateTime.now().year;
  final TextEditingController _last4Digits = TextEditingController();
  // final TextEditingController _invoiceDay = TextEditingController();
  int? _invoiceDay;
  CardsTypeEnum? _type = CardsTypeEnum.Credit;
  CardFlagsEnum? _flag = CardFlagsEnum.Mastercard;

  @override
  void initState() {
    if (widget.cards != null) {
      _brand.text = widget.cards!.brand ?? "";
      // _expiresAt = widget.cards!.expires_at;
      _expMonth = Months.values
          .firstWhere((el) => el.month == widget.cards!.expires_at!.month);
      _expYear = widget.cards!.expires_at!.year;
      _last4Digits.text = widget.cards!.last_4_digits.toString();
      _invoiceDay = widget.cards!.invoice_day;
      _type = widget.cards!.type;
      _flag = widget.cards!.flag;
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
                  child: Text(widget.cards != null
                      ? "Atualizar Dados do Cartão"
                      : "Adicionar Cartão")),
              const SizedBox(height: 50.0),

              ///// brand
              TextFormField(
                autofocus: true,
                autocorrect: true,
                controller: _brand,
                cursorColor: Colors.black,
                maxLength: 50,
                keyboardType: TextInputType.name,
                style: inputTextStyle(),
                selectionHeightStyle: BoxHeightStyle.includeLineSpacingTop,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  LengthLimitingTextInputFormatter(50),
                ],
                decoration: const InputDecoration(
                    // isCollapsed: true,
                    labelText: "Nome do cartão",
                    constraints: BoxConstraints(minHeight: 50.0),
                    counterText: ""),
                validator: (value) {
                  if (value!.length < 3 || value.length > 50) {
                    return "O tamanho minimo é 3 e o máximo é 50";
                  } else if (RegExp(r"[\w\s]+").hasMatch(value) &&
                      StringValidators.sqlInjection(value)) {
                    return "O campo possui caracteres ou expressões inválidas";
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 25.0,
              ),

              /// type
              ///
              DropdownButtonFormField(
                  value: _type,
                  decoration: const InputDecoration(
                      filled: true,
                      counterText: "",
                      label: Text("Tipo"),
                      isDense: false,
                      isCollapsed: true,
                      focusColor: Colors.white,
                      constraints: BoxConstraints(minHeight: 50.0)
                      // hoverColor: Colors.blue
                      ),
                  // itemHeight: 50,
                  dropdownColor: const Color.fromARGB(255, 191, 234, 255),
                  style: inputTextStyle(),
                  isDense: false,
                  isExpanded: true,
                  items: CardsTypeEnum.values
                      .map((el) => DropdownMenuItem(
                            value: el,
                            child: Text(
                              el.type,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    _type = val;
                  }),

              const SizedBox(
                height: 25.0,
              ),

              /// flag
              ///
              DropdownButtonFormField(
                  value: _flag,
                  decoration: const InputDecoration(
                      filled: true,
                      counterText: "",
                      label: Text("Bandeira"),
                      isDense: false,
                      isCollapsed: true,
                      focusColor: Colors.white,
                      constraints: BoxConstraints(minHeight: 50.0)
                      // hoverColor: Colors.blue
                      ),
                  // itemHeight: 50,
                  dropdownColor: const Color.fromARGB(255, 191, 234, 255),
                  style: inputTextStyle(),
                  isDense: false,
                  isExpanded: true,
                  items: CardFlagsEnum.values
                      .map((el) => DropdownMenuItem(
                            value: el,
                            child: Text(
                              el.name.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    _flag = val;
                  }),

              const SizedBox(
                height: 25.0,
              ),

              //// last 4 digits
              ///
              TextFormField(
                autocorrect: true,
                controller: _last4Digits,
                cursorColor: Colors.black,
                maxLength: 4,
                keyboardType: TextInputType.number,
                style: inputTextStyle(),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp("[0-9]{1,4}"))
                ],
                decoration: const InputDecoration(
                    labelText: "Ultimos 4 dígitos do cartão",
                    counterText: "",
                    constraints: BoxConstraints(minHeight: 50.0)),
                validator: (value) {
                  if (value!.isEmpty || value.length > 4) {
                    return "O tamanho do campo deve ser 4";
                  } else if (RegExp(r"[0-9]{4}").hasMatch(value) &&
                      StringValidators.sqlInjection(value)) {
                    return "O campo possui caracteres ou expressões inválidas";
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 25.0,
              ),

              //// invoice Day
              ///
              DropdownButtonFormField<int>(
                value: _invoiceDay,
                decoration: const InputDecoration(
                    filled: true,
                    counterText: "",
                    label: Text("Vencimento da Fatura"),
                    isDense: false,
                    isCollapsed: true,
                    focusColor: Colors.white,
                    constraints: BoxConstraints(minHeight: 50.0)
                    // hoverColor: Colors.blue
                    ),
                // itemHeight: 50,
                dropdownColor: const Color.fromARGB(255, 191, 234, 255),
                style: inputTextStyle(),
                isDense: false,
                isExpanded: true,
                items: List<int>.generate(30, (n) => n + 1)
                    .map((el) => DropdownMenuItem<int>(
                          value: el,
                          child: Text(
                            el.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  _invoiceDay = val;
                },
                validator: (value) {
                  if (value == null || value.isNaN) {
                    return "Campo obrigatório";
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 25.0,
              ),

              //// Expires At
              ///
              ///
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                clipBehavior: Clip.hardEdge,
                children: [
                  DropdownButtonFormField<Months>(
                    value: _expMonth,
                    decoration: const InputDecoration(
                        filled: true,
                        counterText: "",
                        label: Text("Mês de Expiração do cartão"),
                        isDense: false,
                        isCollapsed: true,
                        focusColor: Colors.white,
                        errorMaxLines: 2,
                        constraints:
                            BoxConstraints(maxWidth: 150, minHeight: 50.0)
                        // hoverColor: Colors.blue
                        ),
                    // itemHeight: 50,
                    dropdownColor: const Color.fromARGB(255, 191, 234, 255),
                    style: inputTextStyle(),
                    isDense: false,
                    isExpanded: true,
                    items: Months.values
                        .map((el) => DropdownMenuItem<Months>(
                              value: el,
                              child: Text(
                                el.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      _expMonth = val;
                    },
                    validator: (value) {
                      DateTime now = DateTime.now();
                      if ((_expYear == now.year) && value!.month < now.month) {
                        return "Cartão já vencido, não pode cadastrar";
                      } else if (value == null || value.month.isNaN) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int?>(
                    value: _expYear,
                    decoration: const InputDecoration(
                        filled: true,
                        counterText: "",
                        label: Text("Ano de Expiração do cartão"),
                        isDense: false,
                        isCollapsed: true,
                        focusColor: Colors.white,
                        errorMaxLines: 3,
                        constraints:
                            BoxConstraints(maxWidth: 200, minHeight: 50.0)
                        // hoverColor: Colors.blue
                        ),
                    // itemHeight: 50,
                    dropdownColor: const Color.fromARGB(255, 191, 234, 255),
                    style: inputTextStyle(),
                    isDense: false,
                    isExpanded: true,
                    items:
                        List<int>.generate(50, (it) => DateTime.now().year + it)
                            .map((el) => DropdownMenuItem<int>(
                                  value: el,
                                  child: Text(
                                    el.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ))
                            .toList(),
                    onChanged: (val) {
                      _expYear = val;
                    },
                    validator: (value) {
                      if (value == null || value.isNaN) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  )
                ],
              ),

              const SizedBox(
                height: 25.0,
              ),

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
                            if (widget.cards?.id != null) {
                              ret = await CardsServices().update(CardsDto(
                                  id: widget.cards!.id,
                                  brand: _brand.text,
                                  invoice_day: _invoiceDay,
                                  last_4_digits: _last4Digits.text,
                                  expires_at:
                                      "${_expMonth!.month}/$_expYear",
                                  flag: _flag,
                                  type: _type));
                            } else {
                              ret = await CardsServices().save(CardsDto(
                                  brand: _brand.text,
                                  invoice_day: _invoiceDay,
                                  last_4_digits: _last4Digits.text,
                                  expires_at:
                                      "${_expMonth!.month}/$_expYear",
                                  flag: _flag,
                                  type: _type));
                            }
                            if (ret is CardsDto) {
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
